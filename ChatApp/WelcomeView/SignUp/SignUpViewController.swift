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
        view().signUpAction = signUpPressed
        view().closeAction = closeButtonPressed
        view().presentPicker = presentPicker
        view().nicknameTF.becomeFirstResponder()
    }
    
    fileprivate func view() -> SignUpView {
        return self.view as! SignUpView
    }

    fileprivate func signUpPressed(userName: String, email: String, password: String) {
        FirestoreManager.shared.signUpManager.registerUser(email, password, userName,
                                             image: view().avatarImage.image) { error in
            self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
        }
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
