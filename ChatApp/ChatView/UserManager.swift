//
//  UserManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit

class UserManager {
    
    func fetchUsers(onSuccess: @escaping ((User) -> Void)) {
        let docRef = Constants.FirestoreConst.db.collection(Constants.FirestoreConst.usersCollectionName)
        docRef.getDocuments { snapshot, error in
            if let error = error {
                print("Fetching users failed with: \(error.localizedDescription)")
            }
            if let snapshot = snapshot {
                for documents in snapshot.documents {
                    guard let user = self.transformUser(dict: documents.data()) else { return }
                    onSuccess(user)
                }
            }
        }
    }
    
    func transformUser(dict: [String: Any]) -> User? {
        guard let uid = dict["uid"] as? String,
              let email = dict["email"] as? String,
              let userName = dict["userName"] as? String,
              let profileImageUrl = dict["profileImage"] as? String else {
                  return nil
              }
        let user = User(uid: uid, userName: userName, email: email, profileImageUrl: profileImageUrl)
        return user
    }
}
