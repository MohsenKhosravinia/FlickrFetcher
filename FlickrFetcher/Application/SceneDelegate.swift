//
//  SceneDelegate.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DependencyInjector.shared.homeVC
        window?.makeKeyAndVisible()

    }
}
