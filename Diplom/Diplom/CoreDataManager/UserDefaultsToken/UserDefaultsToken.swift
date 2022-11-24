//
//  UserDefaultsToken.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation

class UserDefaultsToken {
    
    enum Key {
        static let token = "token"
    }
    
    private var token : String?
    
   static func saveToken(token: String){
        UserDefaults.standard.set(token, forKey: Key.token)
    }
   static func loadToken() -> String? {
        let token = UserDefaults.standard.string(forKey: Key.token)
        if let token = token {
            return token
        } else {
            return nil
        }
    }
    static func deleteUDToken(){
        UserDefaults.standard.set("", forKey: Key.token)
    }
}
