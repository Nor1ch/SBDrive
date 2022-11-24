//
//  ProfileViewModel.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit
import Network

struct ProfileViewModelBase {
    var maxSize: Double?
    var usedSize: Double?
    var freeSize: Double?
    var percent : Double?
    
}

class ProfileViewModel {
    typealias Routes = PostedRoute & LoginRoute
    private let route : Routes
    init(route: Routes) {
        self.route = route
    }
    var profileObs: Obs<ProfileViewModelBase?> = Obs(nil)
    private var diskDiscription : ProfileViewModelBase?
    private var networkService = NetworkService()
    var uDProfile = UserDefaultsProfile()

    func getInformationAboutDisk(){
        networkService.getInformationAboutDisk(){ model in
            guard let model = model else {
                let array = self.uDProfile.loadUDProfile()
                self.diskDiscription = ProfileViewModelBase(maxSize: array[0], usedSize: array[1], freeSize: array[2], percent: array[3])
                self.profileObs.value = self.diskDiscription
                return
            }
            guard
                let used = model.usedSize,
                let max = model.maxSize
                                else {return}
            let x = Double(used) / Double(max)
            let y = Double(round(100*x)/100)
            self.diskDiscription = ProfileViewModelBase(maxSize: self.math(max: max),
                                                        usedSize: self.math(max: used),
                                                        freeSize: self.math(max: Double(max), min: used),
                                                        percent: y)
            self.profileObs.value = self.diskDiscription
            self.uDProfile.saveUDProfile(max: self.diskDiscription?.maxSize ?? 0.0, used: self.diskDiscription?.usedSize ?? 0.0, free: self.diskDiscription?.freeSize ?? 0.0, percent: self.diskDiscription?.percent ?? 0.0)
        }
    }
    private func math(max:Double) -> Double{
        let a = max / pow(2, 30)
        let b = Double(round(10*a)/10)
        return b
    }
    private func math(max:Double, min:Double) -> Double{
        let a = max - min
        let b = a / pow(2, 30)
        let z = Double(round(10*b)/10)
        return z 
    }
    func openPosted(){
        route.openPosted()
    }
    
    func logout(){
        route.openLogin(with: ModalTransition())
    }
    func doLogout(userToken: UserToken){
        networkService.doLogout(userToken: userToken)
    }

}
