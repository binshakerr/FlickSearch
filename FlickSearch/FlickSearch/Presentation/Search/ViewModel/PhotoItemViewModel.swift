//
//  PhotoItemViewModel.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation

struct PhotoItemViewModel {
    
    var imageURL: URL?
    
    init(photo: Photo) {
        let imageString = "https://farm\(photo.farm ?? 0).static.flickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
        if let url = URL(string: imageString) {
            imageURL = url 
        }
    }
    
}
