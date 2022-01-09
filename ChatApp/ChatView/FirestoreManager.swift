//
//  FirestoreManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 07.01.2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class FirestoreManager {

    static let shared = FirestoreManager()

    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func logIn(_ email: String, _ password: String,
               onError: @escaping ((Error) -> Void)) {
        
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                onError(error)
                return
            }
            if let result = authDataResult {
                print(result.user.uid)
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.configureInitialVC()
                }
            }
        }
    }
    
    
    func registerUser(_ email: String, _ password: String, _ userName: String,
                      image: UIImage?, onError: @escaping ((Error) -> Void)) {
        auth.createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                onError(error)
                return
            }
            if let authData = authDataResult {
                self.uploadImage(authData, userName, image: image)
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.configureInitialVC()
                }
            }
        }
    }
    
    fileprivate func saveInfoToFirebase(_ authData: AuthDataResult, _ userName: String, _ imageUrl: String) {
        let dict: Dictionary<String, Any> = [
            "uid": authData.user.uid,
            "email": authData.user.email!,
            "userName": userName,
            "profileImage": imageUrl
        ]
        db.collection(Constants.Firestore.usersCollectionName).document(authData.user.uid).setData(dict) { error in
            if let error = error {
                print("Adding to database failed with: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func uploadImage(_ authData: AuthDataResult, _ userName: String, image: UIImage?){
        let storageRef = Storage.storage().reference()
        let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
        
        guard let image = image?.jpegData(compressionQuality: 0.4) else {
            return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageProfileRef.putData(image, metadata: metaData) { storageMetaData, error in
            if let error = error {
                print("Upload image to storage failed with: \(error.localizedDescription)")
                return
            }
            storageProfileRef.downloadURL { url, error in
                if let error = error {
                    print("Can't download image url because: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    let imageUrlString = url.absoluteString
                    self.saveInfoToFirebase(authData, userName, imageUrlString)
                }
            }
        }
    }
    
    
     func fetchUsers(onSuccess: @escaping ((User) -> Void)) {
        let docRef = Firestore.firestore().collection(Constants.Firestore.usersCollectionName)
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
        db.collection(Constants.Firestore.messagesCollectionName).document(currentUserUid).collection(partnerUid).addDocument(data: dict, completion: { error in
            if let error = error {
                print("Adding messsages to database failed with: \(error.localizedDescription)")
            }
        })
        saveToInbox(from: currentUserUid, to: partnerUid, dict: dict)
    }
    
    fileprivate func saveToInbox(from: String, to: String, dict: [String: Any]) {
        let refFrom = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(from).child(to)
        refFrom.updateChildValues(dict)
        
        let refTo = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(to).child(from)
        refTo.updateChildValues(dict)
    }
    
    func recieveMessages(from: String?, to: String?,
                         onSuccess: @escaping ((Message) -> Void)) {
        guard let from = from else { return }
        guard let to = to else { return }

        let docRef = db.collection(Constants.Firestore.messagesCollectionName).document(from).collection(to)
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
//        docRef.getDocuments { snapshot, error in
//            if let error = error {
//                print("Document does not exist: \(error.localizedDescription)")
//                return
//            }
//            if let documents = snapshot?.documents {
//                for document in documents {
//                    if let message = self.transformMessage(dict: document.data()){
//                        onSuccess(message)
//                    }
//                }
//            }
//        }
    }
    
    func transformMessage(dict: [String: Any]) -> Message? {
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
    
    func recieveInboxMessages(uid: String, onSuccess: @escaping ((Inbox) -> Void)) {
        let ref = Database.database().reference().child(Constants.Firestore.inboxCollectionName).child(uid)
        ref.observe(DataEventType.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                self.getUser(uid: snapshot.key) { user in
                    guard  let inbox = self.transformInbox(dict: dict, user: user) else { return }
                    onSuccess(inbox)
                }
            }
        }
    }
    
    func getUser(uid: String, onSuccess: @escaping ((User) -> Void)) {
        let docRef = Firestore.firestore().collection(Constants.Firestore.usersCollectionName).document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Fetching users failed with: \(error.localizedDescription)")
            }
            if let snapshot = snapshot {
                guard let data = snapshot.data() else { return }
                guard let user = self.transformUser(dict: data) else { return }
                onSuccess(user)
                }
        }
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
