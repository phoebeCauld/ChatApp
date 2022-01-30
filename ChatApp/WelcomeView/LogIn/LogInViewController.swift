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
        guard let view = self.view as? LogInView else { return LogInView() }
        return view
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view().endEditing(true)
    }
    
    deinit{
        print("deinit login")
    }
}

extension LogInViewController: LoginViewControllerDelegate {
    
    func logInAction(email: String, password: String) {
        FirestoreManager.shared.logActionManager.logIn(email, password) { error in
            if let error = error {
                self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
            } else {
                FirestoreManager.shared.userManager.isOnline(status: true)
            }
        }
    }
    
    func closeAction() {
        self.dismiss(animated: true)
    }
}
