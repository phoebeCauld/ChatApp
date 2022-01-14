//
//  LogInManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit

class LogInManager {
 
    func logIn(_ email: String, _ password: String,
               onError: @escaping ((Error) -> Void),
               onSuccess: @escaping (() -> Void)) {
        
        Constants.FirestoreConst.auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                onError(error)
                return
            }
            if let _ = authDataResult {
                onSuccess()
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.configureInitialVC()
                }
            }
        }
    }
}
