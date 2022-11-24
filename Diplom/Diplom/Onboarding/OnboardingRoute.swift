//
//  OnboardingRoute.swift
//  Diplom
//
//  Created by Nor1 on 16.11.2022.
//

import Foundation
import UIKit
protocol OnboardingRoute {
    func makeOnboarding() -> UIViewController
}

extension OnboardingRoute where Self: Router {
    func makeOnboarding() -> UIViewController {
        let router = BasicRouter(rootTransition: EmptyTransition())
        let viewModel = OnboardingViewModel(route: router)
        let viewController = OnboardingVC(viewModel: viewModel)
        router.root = viewController
        return viewController
    }
}

extension BasicRouter : OnboardingRoute {}
