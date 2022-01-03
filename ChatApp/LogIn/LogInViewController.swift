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
        print(email, password)
    }
    
    private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    

}
