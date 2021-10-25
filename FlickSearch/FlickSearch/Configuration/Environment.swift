//
//  Environment.swift
//  UGU
//
//  Created by Eslam Shaker on 30/03/2021.
//  Copyright © 2021 Human Soft Solution. All rights reserved.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let flickrKey = "FLICKR_KEY"
            static let flickrSecret = "FLICKR_SECRET"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let value = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return value
    }()
    
    // MARK: - Plist values
    static let baseURL: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return value
    }()
    
    static let flickrKey: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.flickrKey] as? String else {
            fatalError("flickr Key not set in plist for this environment")
        }
        return value
    }()
    
    static let flickrSecret: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.flickrSecret] as? String else {
            fatalError("media URL not set in plist for this environment")
        }
        return value
    }()
    
    
//    //MARK: - other values
//    static let apiURL: String = {
//        return baseURL + "/api/"
//    }()
}
