//
//  ErrorResponse.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation

struct ErrorResponse: Codable {
    var code: Int?
    var message: String?
    var stat: String?
}
