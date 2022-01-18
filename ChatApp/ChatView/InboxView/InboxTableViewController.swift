//
//  InboxTableViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 08.01.2022.
//

import UIKit
import Firebase

class InboxTableViewController: UITableViewController {

    var inboxDict = [String: Inbox]()
    var userInbox = [Inbox]()
    private let currentUser = Constants.FirestoreConst.auth.currentUser
    private var listenerForInbox: ListenerRegistration?


    override func viewDidLoad() {
        super.viewDidLoad()
        observeInbox()
        configTableView()
        configNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    deinit {
        print("deinit inbox")
    }

    fileprivate func observeInbox() {
        guard let currentUserUid = currentUser?.uid else { return }
        FirestoreManager.shared.messageManager.recieveInboxMessages(uid: currentUserUid) { inbox in
            self.inboxDict[inbox.user.uid] = inbox
            self.sortedInbox()
//            if !self.userInbox.contains(where: { $0.user.uid == inbox.user.uid}) {
//                self.userInbox.append(inbox)
//                self.sortedInbox()
//            } else {
//                guard let index = self.userInbox.firstIndex(where: { $0.user.uid == inbox.user.uid}) else { return }
//                self.userInbox.remove(at: index)
//                self.userInbox.append(inbox)
//                self.sortedInbox()
//            }
        } listener: { listener in
            self.listenerForInbox = listener
        }
    }
    
    fileprivate func sortedInbox() {
        userInbox = inboxDict.values.sorted(by: {$0.date > $1.date})
//        userInbox = userInbox.sorted(by: {$0.date > $1.date})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func configTableView() {
        tableView.register(InboxCell.self, forCellReuseIdentifier: Constants.CellIds.inboxCell)
        tableView.separatorStyle = .none
    }
    
    fileprivate func configNavBar() {
        let button = createAvatarButton()
        let avatarButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = avatarButton
    }
    
    fileprivate func createAvatarButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        FirestoreManager.shared.messageManager.getUser(uid: currentUser?.uid ?? "") { user in
            image.loadImage(with: user.profileImageUrl)
        }
        button.layer.cornerRadius = 18
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addSubview(image)
        button.addTarget(self, action: #selector(openSettingsView), for: .touchUpInside)
        return button
    }
    
    @objc fileprivate func openSettingsView() {
        let settingsVC = SettingsTableViewController(style: .grouped)
        settingsVC.view.backgroundColor = Constants.Colors.grayBackground
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInbox.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.inboxCell,
                                                 for: indexPath) as! InboxCell
        let inbox = userInbox[indexPath.row]
        cell.inboxInfo = inbox
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = MessagesViewController()
        chatVC.partnerUser = userInbox[indexPath.row].user
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
