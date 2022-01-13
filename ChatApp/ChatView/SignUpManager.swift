//
//  SignUpManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class SignUpManager {
    
    func registerUser(_ email: String, _ password: String, _ userName: String,
                      image: UIImage?, onError: @escaping ((Error) -> Void)) {
        Constants.FirestoreConst.auth.createUser(withEmail: email, password: password) { authDataResult, error in
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
    
    fileprivate func saveInfoToFirebase(_ authData: AuthDataResult, _ userName: String, _ imageUrl: String) {
        let dict: Dictionary<String, Any> = [
            "uid": authData.user.uid,
            "email": authData.user.email!,
            "userName": userName,
            "profileImage": imageUrl
        ]
        Constants.FirestoreConst.db.collection(Constants.FirestoreConst.usersCollectionName)
            .document(authData.user.uid).setData(dict) { error in
            if let error = error {
                print("Adding to database failed with: \(error.localizedDescription)")
            }
        }
    }
}
