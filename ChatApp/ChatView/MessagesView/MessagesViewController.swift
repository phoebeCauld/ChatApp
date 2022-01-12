//
//  MessagesViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 06.01.2022.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    var partnerUser: User?
    var messages = [Message]()
    let currentUserUid = Auth.auth().currentUser?.uid
    var partnerUid: String?
    
    override func loadView() {
        self.view = MessagesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view().messageCreator.messageField.delegate = self
        view().backgroundColor = Constants.Colors.grayBackground
        view().messageCreator.sendAction = sendButtonDidTapped
        configTableView()
        configNavBar()
    }
    
    fileprivate func view() -> MessagesView {
       return self.view as! MessagesView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        observeMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func configTableView() {
        view().messageScene.register(MessageCell.self, forCellReuseIdentifier: "cell")
        view().messageScene.separatorStyle = .none
        view().messageScene.delegate = self
        view().messageScene.dataSource = self
    }
    
    fileprivate func observeMessages() {
        FirestoreManager.shared.recieveMessages(from: currentUserUid, to: partnerUid) { message in
            if !self.messages.contains(where: {$0.text == message.text && $0.date == message.date}) {
                self.messages.append(message)
                self.sortMessages()
            }
        }
        FirestoreManager.shared.recieveMessages(from: partnerUid, to: currentUserUid) { message in
            if !self.messages.contains(where: {$0.text == message.text && $0.date == message.date}) {
                self.messages.append(message)
                self.sortMessages()
            }
        }
    }
    
    fileprivate func sortMessages() {
        messages = messages.sorted(by: {$0.date < $1.date})
        DispatchQueue.main.async {
            self.view().messageScene.reloadData()
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.view().messageScene.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    fileprivate func configNavBar() {
        guard let user = partnerUser else { return }

        navigationItem.largeTitleDisplayMode = .never
        let avatarView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        image.loadImage(with: user.profileImageUrl)
        image.layer.cornerRadius = 18
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        avatarView.addSubview(image)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
        
        let attributed = NSMutableAttributedString(string: user.userName + "\n" , attributes: [.font : UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
        attributed.append(NSAttributedString(string: "Active", attributes: [.font : UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.systemGreen]))
        view().titleLabel.attributedText = attributed
        navigationItem.titleView = view().titleLabel
    }
    
    fileprivate func sendButtonDidTapped() {
        guard let text = view().messageCreator.messageField.text else { return }
        FirestoreManager.shared.sendMessageToFirebase(text: text, from: currentUserUid, to: partnerUid)
        DispatchQueue.main.async {
            if self.messages.count > 1 {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.view().messageScene.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.view().messageCreator.messageField.text = ""
        }
    }
    
}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if !text.isEmpty {
                self.view().messageCreator.sendButton.isEnabled = true
                self.view().messageCreator.sendButton.tintColor = .systemBlue
            } else {
                self.view().messageCreator.sendButton.isEnabled = false
                self.view().messageCreator.sendButton.tintColor = .lightGray
            }
        }
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
