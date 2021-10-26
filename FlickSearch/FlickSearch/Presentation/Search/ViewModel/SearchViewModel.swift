//
//  SearchViewModel.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelInputs: AnyObject {
    var searchSubject: PublishSubject<String> { get }
}

protocol SearchViewModelOutputs: AnyObject {
    var dataSubject: BehaviorRelay<[PhotoItemViewModel]> { get }
    var stateSubject: BehaviorRelay<DataState> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var screenTitle: String { get }
    var cellIdentifier: String { get }
    var searchControllerPlaceHolder: String { get }
}


protocol SearchViewModelProtocol: SearchViewModelInputs, SearchViewModelOutputs {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelProtocol {
    
    var inputs: SearchViewModelInputs { self }
    var outputs: SearchViewModelOutputs { self }
    
    //MARK: - Inputs
    var searchSubject = PublishSubject<String>()

    //MARK: - Outputs
    let cellIdentifier = "SearchCell"
    let screenTitle = "Flickr Search"
    let searchControllerPlaceHolder = "Search Photos"
    var dataSubject = BehaviorRelay<[PhotoItemViewModel]>(value: [])
    var stateSubject = BehaviorRelay<DataState>(value: .empty)
    var errorSubject = BehaviorRelay<String?>(value: nil)
    
    //MARK: -
    var currentPage = 1
    let manager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    var lastSearchedKeyword = ""
    
    init(){
        bindInputs()
    }
    
    func bindInputs(){
        inputs.searchSubject.subscribe(onNext: { [weak self] searchTerm in
            let text = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
            guard text.count > 0 else {return}
            guard let self = self else { return }
            if searchTerm != self.lastSearchedKeyword {
                self.resetSearch()
            }
            self.lastSearchedKeyword = searchTerm
            self.searchPhotos(keyword: searchTerm)
        }).disposed(by: disposeBag)
    }
    
    func searchPhotos(keyword: String) {
        stateSubject.accept(.loading)
        let request = PhotoService.searchPhotos(keyword: keyword, pageNumber: currentPage)
        manager.request(request, type: SearchResult.self) { [weak self] (result, status) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let mapped = (response.photos?.photo ?? []).map { PhotoItemViewModel(photo: $0)
                }
                self.stateSubject.accept(mapped.count > 0 ? .populated : .empty)
                self.dataSubject.accept(self.dataSubject.value + mapped)
            case .failure(let error):
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            }
        }
    }
    
    func loadMoreItems(_ index: Int) {
        if index == dataSubject.value.count - 1 { // last item
            currentPage += 1
            searchPhotos(keyword: lastSearchedKeyword)
        }
    }
    
    func resetSearch(){
        currentPage = 1
        dataSubject.accept([])
        stateSubject.accept(.empty)
        errorSubject.accept(nil)
        lastSearchedKeyword = ""
    }
    
    func getPhotoItemViewModelAt(_ index: Int) -> PhotoItemViewModel {
        return dataSubject.value[index]
    }
    
}
