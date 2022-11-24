//
//  FilesRoute.swift
//  Diplom
//
//  Created by Nor1 on 08.07.2022.
//

import UIKit

protocol FilesRoute {
    func makeFiles() -> UIViewController
}

extension FilesRoute where Self: Router {
    func makeFiles() -> UIViewController {
        let router = BasicRouter(rootTransition: EmptyTransition())
        let viewModel = FilesViewModel(route: router)
        let viewController = FilesViewController(filesViewModel: viewModel)
        router.root = viewController
        let navigation = UINavigationController(rootViewController: viewController)
        viewController.title = Constants.Text.Files.title
        viewModel.typeVC = "Files"
        navigation.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        navigation.tabBarItem.image = UIImage(named: "archive")
        navigation.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        return navigation
    }
}

extension BasicRouter : FilesRoute {}
