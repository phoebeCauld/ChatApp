//
//  ViewController.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func loadView() {
        self.view = WelcomeView(frame: .zero)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view().delegate = self
    }
    
    func view() -> WelcomeView {
       return self.view as! WelcomeView
    }
}

extension WelcomeViewController: WelcomeViewControllerDelegate {
    func getStartedAction() {
        let signUpVC = SignUpViewController()
        navigationController?.present(signUpVC, animated: true)
    }
    
    func logInAction() {
        let logInVC = LogInViewController()
        navigationController?.present(logInVC, animated: true)
    }
}
