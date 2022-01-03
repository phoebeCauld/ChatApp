//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit
import Firebase
import FirebaseDatabase

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
    
    private func view() -> SignUpView {
        return self.view as! SignUpView
    }
    
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    fileprivate func saveInfoToFirebase(_ authData: AuthDataResult, userName: String) {
        let dict: Dictionary<String, Any> = [
            "uid": authData.user.uid,
            "email": authData.user.email!,
            "userName": userName,
            "profileImage": ""
        ]
        Firestore.firestore().collection("users").document(authData.user.uid).setData(dict) { error in
            if let error = error {
                print("Adding to database failed with: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func registerUser(_ email: String, _ password: String, _ userName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            if let authData = authDataResult {
                self.saveInfoToFirebase(authData, userName: userName)
            }
        }
    }
    
    private func signUpPressed(userName: String, email: String, password: String) {
        registerUser(email, password, userName)
    }
    
    private func closeButtonPressed() {
        self.dismiss(animated: true) 
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
