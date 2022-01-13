//
//  Constants.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 04.01.2022.
//

import UIKit
import Firebase
import FirebaseDatabase

struct Constants {
    struct Images {
        static let messagesImage: String = "bubble.left.and.bubble.right.fill"
        static let contactsImage: String = "person.crop.circle.fill"
        static let settingsImage: String = "gear"
        static let mediaButton: String = "paperclip"
        static let sendButton: String = "arrow.up.circle.fill"
    }
    
    struct FirestoreConst {
        static let db = Firestore.firestore()
        static let auth = Auth.auth()
        static let usersCollectionName: String = "users"
        static let messagesCollectionName: String = "messages"
        static let inboxCollectionName: String = "inbox"
        static let recentMessegeCollectionName: String = "ressentMessages"

    }
    
    struct Colors {
        static let grayBackground: UIColor = UIColor(white: 0.9, alpha: 1)
    }
    
    struct CellIds {
        static let inboxCell = "inboxCell"
        static let logOutCellId: String = "logoutCell"
        static let emailCellId: String = "emailCell"
        static let statusCellId: String = "statusCell"
    }
    
}
