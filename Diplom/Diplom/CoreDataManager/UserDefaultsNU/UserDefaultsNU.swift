//
//  UserDefaultsNU.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation

class UserDefaultsNU {
    
    enum Key {
        static let newUser = "newUser"
    }
   static func saveNU(newUser: Bool){
       UserDefaults.standard.set(newUser, forKey: Key.newUser)
   }
   static func loadNU() -> Bool {
       return UserDefaults.standard.bool(forKey: Key.newUser)
    }
}
