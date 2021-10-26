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
    let screenTitle = "Flickr Search"
    var photos: BehaviorRelay<[PhotoItemViewModel]> = BehaviorRelay(value: [])
    var currentPage = 1
    var lastSearchedKeyword = ""
    let manager = NetworkManager.shared
    
    func searchPhotos(keyword: String) {
        let request = PhotoService.searchPhotos(keyword: keyword, pageNumber: currentPage)
        lastSearchedKeyword = keyword
        manager.request(request, type: SearchResult.self) { (result, status) in
            switch result {
            case .success(let response):
                let mapped = (response.photos?.photo ?? []).map { PhotoItemViewModel(photo: $0)
                }
                self.photos.accept(self.photos.value + mapped)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMoreItems(_ index: Int) {
        if index == photos.value.count - 1 { // last item
            currentPage += 1
            searchPhotos(keyword: lastSearchedKeyword)
        }
    }
    
    func resetSearch(){
        currentPage = 1
        photos.accept([])
    }
    
}
