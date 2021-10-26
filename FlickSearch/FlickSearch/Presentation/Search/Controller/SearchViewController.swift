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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        setupSearchController()
    }
    
    func setupSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchControllerPlaceHolder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func bindViewModel(){
        viewModel.outputs.dataSubject.bind(to: collectionView
                                .rx
                                .items(cellIdentifier: viewModel.cellIdentifier, cellType: SearchCell.self)) { (items, photoItem, cell) in
            cell.imageURL = photoItem.imageURL
        }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .compactMap {self.searchController.searchBar.text}
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
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
        
    }
}
