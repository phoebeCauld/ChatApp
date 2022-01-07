//
//  ContactsTableViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 04.01.2022.
//

import UIKit
import Firebase
import SDWebImage

class ContactsTableViewController: UITableViewController {

    private let cellId = "ContactsCell"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        FirestoreManager.shared.fetchUsers { user in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("logOut action failed with: \(error.localizedDescription)")
        }
        
        // меняет экран
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.configureInitialVC()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactsTableViewCell
        let currentUser = users[indexPath.row]
        cell.userInfo = currentUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partnertUser = users[indexPath.row]
        let chatVC = MessagesViewController()
        chatVC.user = partnertUser
        chatVC.partnerUid = partnertUser.uid
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
