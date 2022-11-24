//
//  WebRoute.swift
//  Diplom
//
//  Created by Nor1 on 27.08.2022.
//

import Foundation
import UIKit

protocol WebRoute {
    func openWeb(title: String, path: String)
}

extension WebRoute where Self: Router {
    func openWeb(with transition: Transition, title: String, path: String){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = WebVC(viewModel: viewModel, name: title, path: path)
        router.root = viewController
        route(to: viewController, as: transition)
    }
    
    func openWeb(title: String, path: String){
        openWeb(with: PushTransition(),title: title, path: path)
    }
}

extension BasicRouter : WebRoute {}
