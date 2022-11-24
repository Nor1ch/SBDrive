//
//  WVLoginViewModel.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation


class WVLoginViewModel {
    typealias Routes = LoginRoute & TabBarRoute
    private let route: Routes
    
    init(route: Routes){
        self.route = route
    }
    
    func openTabBar(){
        route.openTabBar()
    }
}
