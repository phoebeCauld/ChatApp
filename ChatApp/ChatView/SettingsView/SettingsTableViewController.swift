//
//  SettingsTableViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 09.01.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    private let cellId = "cellID"
    var currentUser: User?
    let headerView = AvatarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        configTableView()
    }

    fileprivate func configTableView() {
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(LogOutCell.self, forCellReuseIdentifier: Constants.CellIds.logOutCellId)
    }
    
    fileprivate func configHeaderView() {
        headerView.userNameLabel.text = currentUser?.userName
        headerView.avatarView.loadImage(with: currentUser?.profileImageUrl)
    }
    
    fileprivate func getUser() {
        guard let currentUserUid = Constants.FirestoreConst.auth.currentUser?.uid else { return }
        FirestoreManager.shared.messageManager.getUser(uid: currentUserUid) { user in
            self.currentUser = user
            DispatchQueue.main.async {
                self.configHeaderView()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Here will be your status"
            case 1:
                cell.textLabel?.text = "email: \(currentUser?.email ?? "")"
            default:
                fatalError()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.logOutCellId,
                                                     for: indexPath) as! LogOutCell
            return cell
        default:
            fatalError()
        }
    }
}
