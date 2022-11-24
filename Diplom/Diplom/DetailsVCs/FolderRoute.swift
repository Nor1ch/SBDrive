//
//  FolderRoute.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation
import UIKit

protocol FolderRoute {
    func openFolder(title: String, path: String)
}

extension FolderRoute where Self: Router {
    func openFolder(with transition: Transition, title: String, path: String){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = FolderVC(viewModel: viewModel)
        viewModel.typeVC = "Files"
        viewController.title = title
        viewController.path = path
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func openFolder(title: String, path: String){
        openFolder(with: PushTransition(),title: title, path: path)
    }
}

extension BasicRouter : FolderRoute {}
