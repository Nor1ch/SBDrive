//
//  WVLoginRoute.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation
import UIKit

protocol WVLoginRoute {
    func openWebLogin(title: String, path: String)
}

extension WVLoginRoute where Self: Router {
    func openWebLogin(with transition: Transition, title: String, path: String){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = WVLoginViewModel(route: router)
        let viewController = WVLogin(viewModel: viewModel, title: title, path: path)
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func openWebLogin(title: String, path: String){
        openWebLogin(with: ModalTransition(),title: title, path: path)
    }
}

extension BasicRouter : WVLoginRoute {}
