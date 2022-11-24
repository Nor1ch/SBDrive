//
//  LoginViewModel.swift
//  Diplom
//
//  Created by Nor1 on 16.11.2022.
//

import Foundation

class LoginViewModel {
    private let networkService : NetworkService
    typealias Routes = LoginRoute & WVLoginRoute & TabBarRoute
    private let route: Routes
    private let appID: String =  "b996b9002c9d463b85daac04298e2f1b"
    
    init(route: Routes){
        self.route = route
        self.networkService = NetworkService()
    }
    
    func makeTabBar(){
        route.openTabBar()
    }
    func openWVLogin(title: String, path: String){
        route.openWebLogin(title: title, path: path)
    }
}
