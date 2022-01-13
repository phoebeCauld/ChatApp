//
//  LogInManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit

class LogInManager {
 
    func logIn(_ email: String, _ password: String,
               onError: @escaping ((Error) -> Void)) {
        
        Constants.FirestoreConst.auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                onError(error)
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
