//
//  AppDelegate.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let attrNavigationBar = [
            NSAttributedString.Key.font: Constants.Fonts.headerFont17 as Any
        ]
        UITabBar.appearance().unselectedItemTintColor = Constants.Colors.mainGrey
        UITabBar.appearance().tintColor = Constants.Colors.mainBlue
        UITabBar.appearance().barTintColor = Constants.Colors.mainWhite
        UIBarButtonItem.appearance().tintColor = Constants.Colors.mainGrey
        UINavigationBar.appearance().barTintColor = Constants.Colors.mainWhite
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear as Any], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear as Any], for: .highlighted)
        
        let image = UIImage(named: "vector-back")
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -2), for: .default)

        
        UINavigationBar.appearance().titleTextAttributes = attrNavigationBar
        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(1, for: .default)
        
        NetworkMonitor.shared.startMonitor()
        CoreDataManager.shared.loadCoreDataRecently()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

