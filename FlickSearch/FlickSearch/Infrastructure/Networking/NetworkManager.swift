//
//  FileDownloader.swift
//  UGU
//
//  Created by mohamed ahmed on 4/5/20.
//  Copyright © 2019 Abozaid. All rights reserved.
//

import Alamofire

enum NetworkResult<T> {
    case success(T)
    case failure(String)
}

enum ResponseStatus {
    case success
    case error
    case errors
}

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true

    
    let networkLogger = NetworkLogger()
    return Session(
        configuration: configuration,
        eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T:Codable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>, ResponseStatus) -> Void)
}

class NetworkManager {
    
    private let manager: Session
    var requiresValidation: Bool?
    var unitTestSession: Session?
    static let shared = NetworkManager(manager: customSessionManager, unitTestSession: nil, requiresValidation: true)
    
    init(manager: Session, unitTestSession: Session?, requiresValidation: Bool) {
        self.manager = manager
        self.unitTestSession = unitTestSession
        self.requiresValidation = requiresValidation
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T:Codable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>, ResponseStatus) -> Void){
        
        var dataRequest: DataRequest!
        
        if let unitTestSession = unitTestSession { //Unite test
            // First Validate Request
            dataRequest = (requiresValidation ?? false) ? unitTestSession.request(request).validate() : unitTestSession.request(request)
            // Second Response
            dataRequest.responseJSON { result in
                switch result.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(type.self, from: jsonData)
                        completion(.success(result), .success)
                    } catch let error {
                        completion(.failure(error), .error)
                    }
                    
                case .failure(_):
                    do {
                        guard let data = result.data else { return }
                        let result = try JSONDecoder().decode(type.self, from: data)
                        completion(.success(result), .errors)
                    } catch let error {
                        completion(.failure(error), .error)
                    }
                }
            }
        } else { // Live Date
            
            // 1- Check Internet Connection
            if NetworkReachability.shared.status == .notReachable {
                let userInfo: [String : Any] = [
                    NSLocalizedDescriptionKey:  NSLocalizedString("Connection", value: "Please check your internet connectivity", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Connection", value: "No Internet Connection", comment: "")
                ]
                let error = NSError(domain: "", code: 0, userInfo: userInfo)
                completion(.failure(error), .error)
            }
            
            // 2- Validate Request
            dataRequest = (requiresValidation ?? false) ? customSessionManager.request(request).validate() : customSessionManager.request(request)
            
            // 3- Parse Request
            dataRequest.responseJSON { result in
                let statusCode = result.response?.statusCode ?? 0
                
                switch result.result {
                case .success(let response):
                    switch statusCode {
                    
                    case 200...299:
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                            let result = try JSONDecoder().decode(type.self, from: jsonData)
                            completion(.success(result), .success)
                        } catch let error {
                            print("error: ", error)
                            completion(.failure(error), .error)
                        }
                    case 422: // Dictionary of custom error arrays
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(type.self, from: data)
                            completion(.success(result), .errors)
                        } catch let error {
                            print("error: ", error)
                            completion(.failure(error), .error)
                        }
                    default: // Custom error
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(type.self, from: data)
                            completion(.success(result), .error)
                        } catch let error {
                            print("error: ", error)
                            completion(.failure(error), .error)
                        }
                    }
                    
                case .failure(let error):
                    switch statusCode {
                    case 0: // No Internet Connection
                        completion(.failure(error), .error)
                    case 422: // Dictionary of custom error arrays
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(type.self, from: data)
                            completion(.success(result), .errors)
                        } catch let error {
                            print("error: ", error)
                            completion(.failure(error), .error)
                        }
                    default: // Custom error
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(type.self, from: data)
                            completion(.success(result), .error)
                        } catch let error {
                            print("error: ", error)
                            completion(.failure(error), .error)
                        }
                    }
                }
            }
        }
    }
}
