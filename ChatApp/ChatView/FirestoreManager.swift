//
//  FirestoreManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 07.01.2022.
//

import Foundation

class FirestoreManager {
    
    static let shared = FirestoreManager()

    let logActionManager = LogActionsManager()
    let signUpManager = SignUpManager()
    let userManager = UserManager()
    let messageManager = MessageManager()
}
