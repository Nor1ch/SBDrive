//
//  SceneDelegate.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let router = BasicRouter(rootTransition: EmptyTransition())
//        let tabs = [router.makeProfile(),router.makeRecently(),router.makeFiles()]
//        let tabBar = UITabBarController()
//        tabBar.tabBar.layer.masksToBounds = false
//        tabBar.tabBar.layer.shadowOpacity = 1
//        tabBar.tabBar.layer.shadowRadius = 10
//        tabBar.tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
//        tabBar.tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
//        tabBar.viewControllers = tabs
//        tabBar.tabBar.backgroundColor = .white
//        window?.rootViewController = tabBar
        switch UserDefaultsNU.loadNU() {
        case false:
            window?.rootViewController = router.makeOnboarding()
            UserDefaultsNU.saveNU(newUser: true)
            window?.makeKeyAndVisible()
        case true:
            window?.rootViewController = router.makeLogin()
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
    }


}

