//
//  SearchViewModel.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let cellIdentifier = "SearchCell"
    var photos: [Photo] = [Photo]()
    let manager = NetworkManager.shared
    
    func searchPhotos(keyword: String, pageNumber: Int, completion: @escaping(SearchResult?, String?) -> ()) {
        let request = PhotoService.searchPhotos(keyword: keyword, pageNumber: pageNumber)
        manager.request(request, type: SearchResult.self) { (result, status) in
            switch result {
            case .success(let response):
                self.photos.append(contentsOf: response.photos?.photo ?? [])
                completion(response, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
}
