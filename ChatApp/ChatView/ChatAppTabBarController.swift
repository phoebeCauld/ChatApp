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
                               image: Constants.Images.contactsImage),
            createNavControler(viewControler: UIViewController(),
                               title: "Chats",
                               image: Constants.Images.messagesImage),
            createNavControler(viewControler: UIViewController(),
                               title: "Settings",
                               image: Constants.Images.settingsImage)
        ]
    }
    
    fileprivate func createNavControler(viewControler: UIViewController,
                                        title: String,
                                        image: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewControler)
        navController.navigationBar.prefersLargeTitles = true
        viewControler.view.backgroundColor = .white
        viewControler.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
    }
}
