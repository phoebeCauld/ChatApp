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
    }
    
    private func view() -> SignUpView {
        return self.view as! SignUpView
    }
    
    private func signUpPressed() {
        print("sing up")
    }
    
    private func closeButtonPressed() {
        self.dismiss(animated: true) 
    }

}
