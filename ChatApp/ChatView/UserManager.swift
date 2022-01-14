//
//  UserManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit
import Firebase

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
    
    func isOnline(status: Bool) {
        guard let currentUserUid = Constants.FirestoreConst.auth.currentUser?.uid else { return }
        let dict: [String: Any] = [
            "isOnline": status,
            "latestActive": Date().timeIntervalSince1970
        ]
        let usersRef = Constants.FirestoreConst.db.collection(Constants.FirestoreConst.usersCollectionName)
        let activeStatusRef = usersRef.document(currentUserUid).collection(Constants.FirestoreConst.isOnlinCollectionName)
        
        activeStatusRef.document("isOnline").setData(dict)
    }
    
    func observeActivity(userUid: String, onSuccess: @escaping ((Bool, Double)-> Void),
                         listener: ((ListenerRegistration) -> Void)?) {
        let usersRef = Constants.FirestoreConst.db.collection(Constants.FirestoreConst.usersCollectionName)
        let activeStatusRef = usersRef.document(userUid).collection(Constants.FirestoreConst.isOnlinCollectionName)
        
        let snapshotListener = activeStatusRef.document("isOnline").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Observing activity status failed with: \(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                guard let userStatus = snapshot.data() else { return }
                guard let status = userStatus["isOnline"] as? Bool else { return }
                guard let latestActivity = userStatus["latestActive"] as? Double else { return }
                onSuccess(status, latestActivity)
            }
        }
        listener?(snapshotListener)
    }
}
