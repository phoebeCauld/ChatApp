//
//  LogInManager.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 13.01.2022.
//

import UIKit

class LogActionsManager {
 
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
                self.changeRootVC()
            }
        }
    }
    
    func logOut() {
//        FirestoreManager.shared.userManager.isOnline(status: false)
        do {
            FirestoreManager.shared.userManager.isOnline(status: false)
            try Constants.FirestoreConst.auth.signOut()
        } catch let error as NSError {
            print("logOut action failed with: \(error.localizedDescription)")
        }
        changeRootVC()

    }
    
    fileprivate func changeRootVC() {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.configureInitialVC()
        }
    }
}
