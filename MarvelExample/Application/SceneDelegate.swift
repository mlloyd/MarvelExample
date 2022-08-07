//
//  SceneDelegate.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("failed to find UIWindowScene")
        }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        let coordinator = Coordinator(navigationController: navigationController)
        coordinator.start()

        self.window = window
        window.makeKeyAndVisible()
    }
}
