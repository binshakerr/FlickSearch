//
//  NetworkLogger.swift
//  UGU
//
//  Created by Eslam Shaker on 07/03/2021.
//  Copyright © 2021 Human Soft Solution. All rights reserved.
//

import Alamofire

class NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "com.uguworld.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
