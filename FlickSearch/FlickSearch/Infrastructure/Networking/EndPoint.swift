//
//  EndPoint.swift
//  UGU
//
//  Created by Eslam Shaker on 23/03/2021.
//  Copyright © 2021 Human Soft Solution. All rights reserved.
//

import Alamofire

protocol EndPoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String] { get }
}

extension EndPoint {
    
    func makeDefaultHeaders() -> [String: String] {
        return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
    }
    
    func makeURLRequest() throws -> URLRequest {
        // URL
        let url = try Environment.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        for (key,value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                if urlRequest.httpMethod == "GET" {
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                } else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
