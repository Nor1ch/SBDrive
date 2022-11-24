//
//  NetworkManager.swift
//  Diplom
//
//  Created by Nor1 on 14.09.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    static var reachability = NetworkReachabilityManager(host: "www.google.com")?.isReachable
}
