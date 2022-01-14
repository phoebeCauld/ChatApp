//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by F1xTeoNtTsS on 02.01.2022.
//

import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow()
        window?.windowScene = scene
        window?.makeKeyAndVisible()
        configureInitialVC()
    }
    
    func configureInitialVC(){
        var initialVC: UIViewController
        if let _ = Auth.auth().currentUser {
            initialVC = ChatAppTabBarController()
        } else {
            initialVC = UINavigationController(rootViewController: WelcomeViewController())
        }
        window?.rootViewController = initialVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        FirestoreManager.shared.userManager.isOnline(status: false)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        FirestoreManager.shared.userManager.isOnline(status: true)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        FirestoreManager.shared.userManager.isOnline(status: false)
    }


}

