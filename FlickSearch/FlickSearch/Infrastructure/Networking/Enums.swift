//
//  FileDownloader.swift
//  UGU
//
//  Created by mohamed ahmed on 4/5/20.
//  Copyright © 2019 Abozaid. All rights reserved.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
    case version = "Version"
}

enum ContentType: String {
    case json = "application/json"
    case string = "application/x-www-form-urlencoded"
}
