//
//  ChatAppTabBarController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 04.01.2022.
//

import UIKit

class ChatAppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createNavControler(viewControler: ContactsTableViewController(),
                               title: "Contacts",
                               image: Constants.Images.contactsImage,
                               backgroundColor: .white),
            createNavControler(viewControler: InboxTableViewController(),
                               title: "Chats",
                               image: Constants.Images.messagesImage,
                               backgroundColor: .white),
            createNavControler(viewControler: SettingsTableViewController(style: .grouped),
                               title: "Settings",
                               image: Constants.Images.settingsImage,
                               backgroundColor: Constants.Colors.grayBackground)
        ]
    }
    
    fileprivate func createNavControler(viewControler: UIViewController,
                                        title: String,
                                        image: String, backgroundColor: UIColor) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewControler)
        navController.navigationBar.prefersLargeTitles = true
        viewControler.view.backgroundColor = backgroundColor
        viewControler.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
    }
}
