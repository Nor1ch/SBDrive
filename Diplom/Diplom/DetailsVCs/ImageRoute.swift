//
//  ImageRoute.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation
import UIKit


protocol ImageRoute {
    func openImage(title: String, path: String, date: String, onDisk: String)
}

extension ImageRoute where Self: Router {
    func openImage(with transition: Transition, title: String, path: String, date: String, onDisk: String){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = ImageVC(viewModel: viewModel)
        viewController.date = date
        viewController.title = title
        viewController.path = path
        viewController.onDisk = onDisk
        router.root = viewController
        route(to: viewController, as: transition)
        let attrNavigationBar = [
                    NSAttributedString.Key.font: Constants.Fonts.headerFont17 as Any,
                    NSAttributedString.Key.foregroundColor: Constants.Colors.mainWhite as Any
                ]
        viewController.navigationController?.navigationBar.titleTextAttributes = attrNavigationBar
        viewController.tabBarController?.tabBar.isHidden = true
    }
    
    func openImage(title: String, path: String, date: String, onDisk: String){
        openImage(with: PushTransition(),title: title, path: path, date: date, onDisk: onDisk)
    }
}

extension BasicRouter : ImageRoute {}
