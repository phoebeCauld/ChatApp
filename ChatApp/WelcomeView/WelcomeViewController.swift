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
        view().logInAction = logInPressed
        view().getStartedAction = getStartedPressed
    }
    
    func view() -> WelcomeView {
       return self.view as! WelcomeView
    }
    
    private func getStartedPressed() {
        let signUpVC = SignUpViewController()
        navigationController?.present(signUpVC, animated: true)
//        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func logInPressed() {
        let logInVC = LogInViewController()
        navigationController?.present(logInVC, animated: true)    }

}

