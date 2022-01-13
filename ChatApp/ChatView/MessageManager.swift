//
//  MessageManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit

class MessageManager {
    
    func sendMessageToFirebase(text: String, from: String?, to: String?) {
        guard let currentUserUid = from else { return }
        guard let partnerUid = to else { return }
        
        let date = Date().timeIntervalSince1970
        let dict: Dictionary<String, Any> = [
            "from": currentUserUid,
            "to": partnerUid,
            "text": text,
            "date": date
        ]
        Constants.FirestoreConst.db.collection(Constants.FirestoreConst.messagesCollectionName).document(currentUserUid).collection(partnerUid).addDocument(data: dict, completion: { error in
            if let error = error {
                print("Adding messsages to database failed with: \(error.localizedDescription)")
            }
        })
        saveToInbox(from: currentUserUid, to: partnerUid, dict: dict)
    }
    
    fileprivate func saveToInbox(from: String, to: String, dict: [String: Any]) {
        
        Constants.FirestoreConst.db.collection(Constants.FirestoreConst.inboxCollectionName)
            .document(from).collection("ressentMessages").document(to).setData(dict)
        Constants.FirestoreConst.db.collection(Constants.FirestoreConst.inboxCollectionName)
            .document(to).collection("ressentMessages").document(from).setData(dict)
    }
    
    func recieveMessages(from: String?, to: String?,
                         onSuccess: @escaping ((Message) -> Void)) {
        guard let from = from else { return }
        guard let to = to else { return }
        
        let docRef = Constants.FirestoreConst.db
            .collection(Constants.FirestoreConst.messagesCollectionName).document(from).collection(to)
        docRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Document does not exist: \(error.localizedDescription)")
                return
            }
            if let documents = snapshot?.documents {
                for document in documents {
                    if let message = self.transformMessage(dict: document.data()){
                        onSuccess(message)
                    }
                }
            }
        }
    }
    
    func recieveInboxMessages(uid: String, onSuccess: @escaping ((Inbox) -> Void)) {
        let ref = Constants.FirestoreConst.db
            .collection(Constants.FirestoreConst.inboxCollectionName).document(uid)
            .collection(Constants.FirestoreConst.recentMessegeCollectionName)
        ref.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Document does not exist: \(error.localizedDescription)")
                return
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    guard let documents = snapshot?.documents else { return }
                    for document in documents {
                        self.getInbox(dict: document.data()) { inbox in
                            onSuccess(inbox)
                        }
                    }
                }
            })
        }
    }
    
    fileprivate func getInbox(dict: [String: Any], onSuccess: @escaping ((Inbox) -> Void)) {
        guard let uidFrom = dict["from"] as? String else { return }
        guard let uidTo = dict["to"] as? String else { return }
        
        if Constants.FirestoreConst.auth.currentUser?.uid == uidFrom {
            self.getUser(uid: uidTo) { user in
                guard let inbox = self.transformInbox(dict: dict, user: user) else { return }
                onSuccess(inbox)
            }
        } else {
            self.getUser(uid: uidFrom) { user in
                guard let inbox = self.transformInbox(dict: dict, user: user) else { return }
                onSuccess(inbox)
            }
        }
    }
    
    func getUser(uid: String, onSuccess: @escaping ((User) -> Void)) {
        let docRef = Constants.FirestoreConst.db.collection(Constants.FirestoreConst.usersCollectionName).document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Fetching users failed with: \(error.localizedDescription)")
            }
            if let snapshot = snapshot {
                guard let data = snapshot.data() else { return }
                guard let user = FirestoreManager.shared.userManager.transformUser(dict: data) else { return }
                onSuccess(user)
            }
        }
    }
    
    fileprivate func transformMessage(dict: [String: Any]) -> Message? {
        guard let from = dict["from"] as? String,
              let to = dict["to"] as? String,
              let text = dict["text"] as? String,
              let date = dict["date"] as? Double else {
                  return nil
              }
        let message = Message(from: from,
                              to: to,
                              text: text,
                              date: date)
        return message
    }
    
    func transformInbox(dict: [String: Any], user: User) -> Inbox? {
        guard let from = dict["from"] as? String,
              let to = dict["to"] as? String,
              let text = dict["text"] as? String,
              let date = dict["date"] as? Double else {
                  return nil
              }
        let inbox = Inbox(user: user, from: from,
                          to: to,
                          text: text,
                          date: date)
        return inbox
    }
}
