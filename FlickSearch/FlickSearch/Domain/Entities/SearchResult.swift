//
//  SearchResult.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation

struct SearchResult: Codable {
    var photos: Photos?
    var stat: String?
}

struct Photos: Codable {
    var page, pages, perpage, total: Int?
    var photo: [Photo]?
}
