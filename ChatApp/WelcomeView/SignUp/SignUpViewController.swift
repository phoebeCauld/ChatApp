//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    override func loadView() {
        self.view = SignUpView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view().delegate = self
        view().nicknameTF.becomeFirstResponder()
    }

    fileprivate func view() -> SignUpView {
        return self.view as! SignUpView
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view().endEditing(true)
    }
}

extension SignUpViewController: SignUpViewControllerDelegate {
    
    func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func signUpAction(userName: String, email: String, password: String) {
        FirestoreManager.shared.signUpManager.registerUser(email, password, userName,
                                             image: view().avatarImage.image) { error in
            self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
        } onSuccess: {
            FirestoreManager.shared.userManager.isOnline(status: true)
        }
    }
    
    func closeAction() {
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

