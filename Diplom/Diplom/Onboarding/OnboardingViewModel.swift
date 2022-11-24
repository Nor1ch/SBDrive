//
//  OnboardingViewModel.swift
//  Diplom
//
//  Created by Nor1 on 16.11.2022.
//

import Foundation
import UIKit

class OnboardingViewModel {
    typealias Routes = LoginRoute & OnboardingRoute
    private let route : Routes
    let slides : [OnboardingSlide] = [
        OnboardingSlide(image: UIImage(named: "onboarding1") ?? UIImage(), description: Constants.Text.Onboarding.description_1),
        OnboardingSlide(image: UIImage(named: "onboarding2") ?? UIImage(), description: Constants.Text.Onboarding.description_2),
        OnboardingSlide(image: UIImage(named: "onboarding3") ?? UIImage(), description: Constants.Text.Onboarding.description_3)
    ]
    init(route: Routes){
        self.route = route
    }
    
    func openLogin(){
        route.openLogin(with: ModalTransition())
    }
}
