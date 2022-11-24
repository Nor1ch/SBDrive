//
//  PostedRoute.swift
//  Diplom
//
//  Created by Nor1 on 13.07.2022.
//

import Foundation
import UIKit

protocol PostedRoute {
    func openPosted()
}

extension PostedRoute where Self: Router {
    func openPosted(with transition: Transition){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = PostedViewController(viewModel: viewModel)
        viewController.title = Constants.Text.Published.title
        router.root = viewController
        viewModel.typeVC = "Posted"
        route(to: viewController, as: transition)
    }
    
    func openPosted(){
        openPosted(with: PushTransition())
    }
}

extension BasicRouter : PostedRoute {}
