//
//  ProfileRoute.swift
//  Diplom
//
//  Created by Nor1 on 08.07.2022.
//

import UIKit

protocol ProfileRoute {
    func makeProfile() -> UIViewController
}

extension ProfileRoute where Self: Router {
    func makeProfile() -> UIViewController {
        let router = BasicRouter(rootTransition: EmptyTransition())
        let viewModel = ProfileViewModel(route: router)
        let viewController = ProfileViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: viewController)
        router.root = viewController
        viewController.title = Constants.Text.Profile.title
        navigation.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        navigation.tabBarItem.image = UIImage(named: "person")
        navigation.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
//        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
        return navigation
    }
}

extension BasicRouter : ProfileRoute {}
