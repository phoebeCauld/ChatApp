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
        view().closeAction = closeButtonPressed
        view().logInAction = logInPressed
        view().emailTF.becomeFirstResponder()
    }

    private func view() -> LogInView {
        return self.view as! LogInView
    }
    
    private func logInPressed(_ email: String, _ password: String) {
        FirestoreManager.shared.loginManager.logIn(email, password) { error in
            self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
        } onSuccess: {
            FirestoreManager.shared.userManager.isOnline(status: true)
        }
    }
    
    private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
}
