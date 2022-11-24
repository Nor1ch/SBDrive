//
//  NetworkMonitor.swift
//  Diplom
//
//  Created by Nor1 on 02.11.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private(set) var isConnected = false
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    func startMonitor(){
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
        print("monitor started")
    }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatus changed")
}
