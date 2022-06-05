//
//  SceneDelegate.swift
//  MyCryptoApp
//
//  Created by Shad Mazumder on 5/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = RootComposer().startingViewController
        window?.makeKeyAndVisible()
    }
}

