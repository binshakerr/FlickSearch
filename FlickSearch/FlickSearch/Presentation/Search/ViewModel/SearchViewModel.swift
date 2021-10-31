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
    var pastSearches: BehaviorRelay<[String]> { get }
    var screenTitle: String { get }
    var cellIdentifier: String { get }
    var savedCellIdentifier: String { get }
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
    let savedCellIdentifier = "SavedCell"
    let screenTitle = "Flickr Search"
    let searchControllerPlaceHolder = "Search Photos"
    var dataSubject = BehaviorRelay<[PhotoItemViewModel]>(value: [])
    var stateSubject = BehaviorRelay<DataState>(value: .empty)
    var errorSubject = BehaviorRelay<String?>(value: nil)
    var pastSearches = BehaviorRelay<[String]>(value: [])
    var isSearching = BehaviorRelay<Bool>(value: false)

    
    //MARK: -
    private var currentPage = 1
    private var networkManager: NetworkManagerType
    private var coreDataManager: CoreDataMangerType
    private let disposeBag = DisposeBag()
    private var lastSearchedKeyword = ""
    private let entityName = "SavedSearch"
    
    init(networkManager: NetworkManagerType = NetworkManager.shared, coreDataManager: CoreDataMangerType = CoreDataManager.shared){
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        bindInputs()
        loadSavedSearches()
    }
    
    func bindInputs(){
        inputs.searchSubject.subscribe(onNext: { [weak self] searchTerm in
            self?.searchPhotos(keyword: searchTerm)
        }).disposed(by: disposeBag)
    }
    
    func searchPhotos(keyword: String) {
        let text = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 0 else {return}
        if keyword != self.lastSearchedKeyword {
            resetSearch()
        }
        lastSearchedKeyword = keyword
        save(searchTerm: keyword)
        isSearching.accept(true)
        stateSubject.accept(.loading)
        
        let request = PhotoService.searchPhotos(keyword: keyword, pageNumber: currentPage)
        networkManager.request(request, type: SearchResult.self) { [weak self] (result, status) in
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
    
    func getSavedSearchAt(_ index: Int) -> String {
        return pastSearches.value[index]
    }
    
    func save(searchTerm: String) {
        let values = ["text": searchTerm]
        coreDataManager.save(values: values, entityName: entityName)
    }
    
    func loadSavedSearches(){
        if let searches = coreDataManager.loadObjects(entityName) {
            let texts = searches.map({
                $0.value(forKeyPath: "text") as? String ?? ""
            })
            pastSearches.accept(texts.reversed())
        }
    }
    
}
