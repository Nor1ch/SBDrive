//
//  EditRoute.swift
//  Diplom
//
//  Created by Nor1 on 17.08.2022.
//

import Foundation
import UIKit

protocol EditRoute {
    func openEdit(title: String, path: String, file: String, image: UIImage)
}

extension EditRoute where Self: Router {
    func openEdit(with transition: Transition, title: String, path: String, file: String, image: UIImage){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = EditVC(viewModel: viewModel, path: path, title: title, file: file, image: image)
        viewController.title = Constants.Text.Edit.changeName
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func openEdit(title: String, path: String, file: String, image: UIImage){
        openEdit(with: PushTransition(),title: title, path: path, file: file, image: image)
    }
}

extension BasicRouter : EditRoute {}
