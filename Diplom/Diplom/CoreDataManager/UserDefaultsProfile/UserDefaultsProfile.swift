//
//  UserDefaultsProfile.swift
//  Diplom
//
//  Created by Nor1 on 14.09.2022.
//

import Foundation


class UserDefaultsProfile {
    
    enum Keys {
        static let maxSize = "maxSize"
        static let usedSize = "usedSize"
        static let freeSize = "freeSize"
        static let percent = "percent"
    }
    
    private var maxSize : Double?
    private var usedSize : Double?
    private var freeSize : Double?
    private var percent : Double?
    
    func loadUDProfile() -> [Double] {
        var array : [Double] = []
        self.maxSize = UserDefaults.standard.double(forKey: Keys.maxSize)
        self.usedSize = UserDefaults.standard.double(forKey: Keys.usedSize)
        self.freeSize = UserDefaults.standard.double(forKey: Keys.freeSize)
        self.percent = UserDefaults.standard.double(forKey: Keys.percent)
        array.append(maxSize ?? 0.0)
        array.append(usedSize ?? 0.0)
        array.append(freeSize ?? 0.0)
        array.append(percent ?? 0.0)
        print("loadedProfile")
        return array
    }
    
    func saveUDProfile(max: Double, used: Double, free: Double, percent: Double){
        UserDefaults.standard.set(max, forKey: Keys.maxSize)
        UserDefaults.standard.set(used, forKey: Keys.usedSize)
        UserDefaults.standard.set(free, forKey: Keys.freeSize)
        UserDefaults.standard.set(percent, forKey: Keys.percent)
        print("savedProfile")
    }
    
    static func deleteUDProfile(){
        UserDefaults.standard.set(0.0, forKey: Keys.maxSize)
        UserDefaults.standard.set(0.0, forKey: Keys.usedSize)
        UserDefaults.standard.set(0.0, forKey: Keys.freeSize)
        UserDefaults.standard.set(0.0, forKey: Keys.percent)
        print("udprofile deleted")
    }
}
