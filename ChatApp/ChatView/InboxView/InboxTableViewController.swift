//
//  InboxTableViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 08.01.2022.
//

import UIKit

class InboxTableViewController: UITableViewController {
    let cellId = "inboxCell"
    var userInbox = [Inbox]()
    let currentUser = FirestoreManager.shared.auth.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        observeInbox()
        configTableView()
        configNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInbox = []
        observeInbox()
    }
    
    fileprivate func observeInbox() {
        guard let currentUserUid = currentUser?.uid else { return }
        FirestoreManager.shared.recieveInboxMessages(uid: currentUserUid) { inbox in
            if !self.userInbox.contains(where: { $0.user.uid == inbox.user.uid}) {
                self.userInbox.append(inbox)
                self.sortedInbox()
            }
        }
    }
    
    fileprivate func sortedInbox() {
        userInbox = userInbox.sorted(by: {$0.date > $1.date})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func configTableView() {
        tableView.register(InboxCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    
    fileprivate func configNavBar() {
        let avatarView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        FirestoreManager.shared.getUser(uid: currentUser?.uid ?? "") { user in
            image.loadImage(with: user.profileImageUrl)
        }
        image.layer.cornerRadius = 18
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        avatarView.addSubview(image)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
        let gesture = UIGestureRecognizer()
        gesture.addTarget(self, action: #selector(openSettingsView))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func openSettingsView() {
        let settingsVC = SettingsTableViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInbox.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InboxCell
        let inbox = userInbox[indexPath.row]
        cell.inboxInfo = inbox
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = MessagesViewController()
        chatVC.partnerUser = userInbox[indexPath.row].user
        chatVC.partnerUid = userInbox[indexPath.row].user.uid
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
