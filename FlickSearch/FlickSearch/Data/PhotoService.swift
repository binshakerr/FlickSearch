//
//  PhotoService.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Alamofire

enum PhotoService {
    case searchPhotos(keyword: String, pageNumber: Int)
}

extension PhotoService: EndPoint {
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchPhotos:
            return "/services/rest"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        case let .searchPhotos(keyword, pageNumber):
            let parameters: [String: Any] =
            ["method": "flickr.photos.search",
             "api_key": Environment.flickrKey,
             "format": "json",
             "nojsoncallback": 1,
             "per_page": 20,
             "text": keyword,
             "page": pageNumber]
            return parameters
        }
    }
    
    var headers: [String: String] {
        return makeDefaultHeaders()
    }
    
}


extension PhotoService: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return try makeURLRequest()
    }
}
