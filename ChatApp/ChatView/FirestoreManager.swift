//
//  FirestoreManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 07.01.2022.
//

import Foundation

class FirestoreManager {
    
    static let shared = FirestoreManager()

    let loginManager = LogInManager()
    let signUpManager = SignUpManager()
    let userManager = UserManager()
    let messageManager = MessageManager()
}

//MARK: -  realtime database firestore method to check inbox

//MARK: save method

//    fileprivate func saveToInbox(from: String, to: String, dict: [String: Any]) {
//        let refFrom = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(from).child(to)
//        refFrom.updateChildValues(dict)
//
//        let refTo = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(to).child(from)
//        refTo.updateChildValues(dict)
//    }

//MARK: recive method

//func recieveInboxMessages(uid: String, onSuccess: @escaping ((Inbox) -> Void)) {
//    let ref = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(uid)
//
//    ref.observe(.childAdded) { snapshot in
//        if let dict = snapshot.value as? [String: Any] {
//            self.getUser(uid: snapshot.key) { user in
//                guard  let inbox = self.transformInbox(dict: dict, user: user) else { return }
//                onSuccess(inbox)
//            }
//        }
//    }
//    ref.observe(.childChanged) { snapshot in
//        if let dict = snapshot.value as? [String: Any] {
//            self.getUser(uid: snapshot.key) { user in
//                guard  let inbox = self.transformInbox(dict: dict, user: user) else { return }
//                onSuccess(inbox)
//            }
//        }
//    }
//}
