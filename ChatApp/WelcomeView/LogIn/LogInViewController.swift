//
//  LogInViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 03.01.2022.
//

import UIKit

class LogInViewController: UIViewController {

    override func loadView() {
        self.view = LogInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view().delegate = self
        view().emailTF.becomeFirstResponder()
    }

    private func view() -> LogInView {
        return self.view as! LogInView
    }
    
    private func logInPressed(_ email: String, _ password: String) {

    }
    
    deinit{
        print("deinit login")
    }
    
    private func closeButtonPressed() {
        
    }
}

extension LogInViewController: LoginViewControllerDelegate {
    
    func logInAction(email: String, password: String) {
        FirestoreManager.shared.logActionManager.logIn(email, password) { error in
            self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
        } onSuccess: {
            FirestoreManager.shared.userManager.isOnline(status: true)
        }
    }
    
    func closeAction() {
        self.dismiss(animated: true)
    }
}
