//
//  XCTestCase+Extensions.swift
//  
//
//  Created by Eslam Shaker on 10/07/2021.
//

import XCTest
import Alamofire

extension XCTestCase {
    func getMockSessionFor(_ data: Data) -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        MockURLProtocol.stubResponseData = data
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        return Session(configuration: configuration)
    }
}
