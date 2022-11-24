//
//  RecentlyRoute.swift
//  Diplom
//
//  Created by Nor1 on 08.07.2022.
//

import Foundation
import UIKit

protocol RecentlyRoute {
    func makeRecently() -> UIViewController
}

extension RecentlyRoute where Self: Router {
    func makeRecently() -> UIViewController {
        let router = BasicRouter(rootTransition: EmptyTransition())
        let viewModel = FilesViewModel(route: router)
        let viewController = RecentlyViewController(viewModel: viewModel)
        router.root = viewController
        let navigation = UINavigationController(rootViewController: viewController)
        viewModel.typeVC = "Recently"
        viewController.title = Constants.Text.Recently.title
        navigation.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        navigation.tabBarItem.image = UIImage(named: "file")
        navigation.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        return navigation
    }
}

extension BasicRouter : RecentlyRoute {}
