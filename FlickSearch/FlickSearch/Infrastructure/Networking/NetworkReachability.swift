//
//  NetworkReachability.swift
//  UGU
//
//  Created by Eslam Shaker on 07/03/2021.
//  Copyright © 2021 Human Soft Solution. All rights reserved.
//

import Alamofire

class NetworkReachability {
    static let shared = NetworkReachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": false])
            case .reachable(.cellular):
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": true])
            case .reachable(.ethernetOrWiFi):
                NotificationCenter.default.post(name: .connectivityStatusChanged, object: nil, userInfo: ["status": true])
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    var status: NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachabilityManager?.status ?? .notReachable
    }
}


extension Notification.Name {
    static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}
