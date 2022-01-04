//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController {

    override func loadView() {
        self.view = SignUpView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view().signUpAction = signUpPressed
        view().closeAction = closeButtonPressed
        view().presentPicker = presentPicker
    }
    
    fileprivate func view() -> SignUpView {
        return self.view as! SignUpView
    }

    fileprivate func signUpPressed(userName: String, email: String, password: String) {
        registerUser(email, password, userName)
    }
    
    fileprivate func closeButtonPressed() {
        self.dismiss(animated: true)
    }

    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }

//MARK: - Registration actions

    fileprivate func registerUser(_ email: String, _ password: String, _ userName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            if let authData = authDataResult {
                self.saveInfoToFirebase(authData, userName: userName)
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.configureInitialVC()
                }
            }
        }
    }
    
    fileprivate func saveInfoToFirebase(_ authData: AuthDataResult, userName: String) {
        let imageUrl = uploadImage(authData) ?? ""
        let dict: Dictionary<String, Any> = [
            "uid": authData.user.uid,
            "email": authData.user.email!,
            "userName": userName,
            "profileImage": imageUrl
        ]
        Firestore.firestore().collection("users").document(authData.user.uid).setData(dict) { error in
            if let error = error {
                print("Adding to database failed with: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func uploadImage(_ authData: AuthDataResult) -> String? {
        var imageUrlString: String?
        let storageRef = Storage.storage().reference()
        let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
        
        guard let image = view().avatarImage.image?.jpegData(compressionQuality: 0.4) else {
            return nil }
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
                    imageUrlString = url.absoluteString
                }
            }
        }
        return imageUrlString
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view().endEditing(true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            view().avatarImage.image = selectedImage
        }
        if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            view().avatarImage.image = originalImage
        }
        
        picker.dismiss(animated: true)
    }
}
