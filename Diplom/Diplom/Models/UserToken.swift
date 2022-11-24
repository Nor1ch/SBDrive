//
//  UserToken.swift
//  Diplom
//
//  Created by Nor1 on 24.11.2022.
//

import Foundation

struct UserToken : Codable {
    let access_token: String?
    let clien_id: String?
    let clien_secret: String?
    
    enum CodingKeys: String, CodingKey {
        case access_token = "access_token"
        case clien_id = "clien_id"
        case clien_secret = "clien_secret"
    }
    
    init(access_token: String, clien_id: String, clien_secret: String){
        self.access_token = access_token
        self.clien_id = clien_id
        self.clien_secret = clien_secret
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        clien_id = try values.decodeIfPresent(String.self, forKey: .clien_id)
        clien_secret = try values.decodeIfPresent(String.self, forKey: .clien_secret)
    }
}
