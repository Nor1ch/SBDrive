//
//  DocRoute.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation
import UIKit

protocol DocRoute {
    func openDoc(title: String, path: String, file: String)
}

extension DocRoute where Self: Router {
    func openDoc(with transition: Transition, title: String, path: String, file: String){
        let router = BasicRouter(rootTransition: transition)
        let viewModel = FilesViewModel(route: router)
        let viewController = DocVC(viewModel: viewModel, path: path, file: file, title: title)
        router.root = viewController
        
        route(to: viewController, as: transition)
    }
    
    func openDoc(title: String, path: String, file: String){
        openDoc(with: PushTransition(),title: title, path: path, file: file)
    }
}

extension BasicRouter : DocRoute {}
