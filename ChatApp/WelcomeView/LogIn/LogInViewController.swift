//
//  LogInViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 03.01.2022.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    override func loadView() {
        self.view = LogInView()
        view().closeAction = closeButtonPressed
        view().logInAction = logInPressed
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func view() -> LogInView {
        return self.view as! LogInView
    }
    
    private func logInPressed(_ email: String, _ password: String) {
        logIn(email, password)
    }
    
    private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    
    
    fileprivate func logIn(_ email: String, _ password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                self.view().addErrorLabels(for: UITextField(), error: error.localizedDescription)
                print(error.localizedDescription)
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

}
