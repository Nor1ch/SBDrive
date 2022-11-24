//
//  TabBarRoute.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation
import UIKit

protocol TabBarRoute {
    func openTabBar()
}

extension TabBarRoute where Self: Router {
    func openTabBar(with transition: Transition){
        let router = BasicRouter(rootTransition: EmptyTransition())
        let tabs = [router.makeProfile(),router.makeRecently(),router.makeFiles()]
        let tabBar = UITabBarController()
        tabBar.tabBar.layer.masksToBounds = false
        tabBar.tabBar.layer.shadowOpacity = 1
        tabBar.tabBar.layer.shadowRadius = 10
        tabBar.tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        tabBar.viewControllers = tabs
        tabBar.tabBar.backgroundColor = .white
        router.root = tabBar
        route(to: tabBar, as: transition)
    }
    func openTabBar(){
        openTabBar(with: ModalTransition())
    }
}

extension BasicRouter : TabBarRoute {}
