//
//  LoginRoute.swift
//  Diplom
//
//  Created by Nor1 on 16.11.2022.
//

import Foundation
import UIKit

protocol LoginRoute {
    func openLogin(with transition: Transition)
    func makeLogin() -> UIViewController
}


extension LoginRoute where Self: Router {
    func openLogin(with transition: Transition){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = LoginViewModel(route: router)
        let viewController = LoginVC(viewModel: viewModel)
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func makeLogin() -> UIViewController{
        let router = BasicRouter(rootTransition: EmptyTransition())
        let viewModel = LoginViewModel(route: router)
        let viewController = LoginVC(viewModel: viewModel)
        router.root = viewController
        return viewController
    }
}

extension BasicRouter : LoginRoute {}
