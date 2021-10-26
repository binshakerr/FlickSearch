//
//  SearchViewController.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.register(UINib(nibName: viewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: viewModel.cellIdentifier)
        return collection
    }()
    
    lazy var savedSearchTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.savedCellIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.backgroundColor = .systemBackground
        view.addSubview(savedSearchTable)
        view.addSubview(collectionView)
        savedSearchTable.fillSuperviewSafeArea()
        collectionView.fillSuperviewSafeArea()
        collectionView.isHidden = true
        setupSearchController()
    }
    
    func setupSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchControllerPlaceHolder
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func bindViewModel(){
        viewModel.outputs.dataSubject
            .bind(to: collectionView
                    .rx
                    .items(cellIdentifier: viewModel.cellIdentifier, cellType: SearchCell.self)) { (items, photoItem, cell) in
                cell.imageURL = photoItem.imageURL
            }
                    .disposed(by: disposeBag)
        
        viewModel.outputs.stateSubject
            .subscribe(onNext:  { [weak self] state in
            guard let self = self else { return }
            state == .loading ? self.startLoading() : self.stopLoading()
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorSubject
            .subscribe(onNext:  { [weak self] message in
            guard let self = self, let message = message else { return }
            self.showSimpleAlert(title: "Error", message: message)
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.pastSearches
            .bind(to: savedSearchTable
                    .rx
                    .items(cellIdentifier: viewModel.savedCellIdentifier, cellType: UITableViewCell.self)) { (items, searchTerm, cell) in
                cell.textLabel?.text = searchTerm
            }
                    .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .compactMap {self.searchController.searchBar.text}
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        viewModel.isSearching.subscribe(onNext: { [weak self] searching in
            self?.savedSearchTable.isHidden = searching
            self?.collectionView.isHidden = !searching
        })
        .disposed(by: disposeBag)

    }
    
    func openPhotoDetails(_ index: Int) {
        let photo = viewModel.getPhotoItemViewModelAt(index)
        let controller = PhotoDetailsViewController(photo: photo)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}



extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 15
        let height = collectionView.bounds.height / 3 - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMoreItems(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openPhotoDetails(indexPath.item)
    }
}


extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = viewModel.getSavedSearchAt(indexPath.row)
        viewModel.searchPhotos(keyword: text)
    }
    
}
