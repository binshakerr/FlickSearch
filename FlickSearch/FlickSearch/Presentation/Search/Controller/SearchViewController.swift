//
//  SearchViewController.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: viewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: viewModel.cellIdentifier)
        collection.backgroundColor = .yellow
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.searchPhotos(keyword: "cat", pageNumber: 1) { photos, error in
            
            if let error = error {
                self.showSimpleAlert(title: "Error", message: error)
            } else {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func setupUI(){
        view.backgroundColor = .red
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}



extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
        let currentImage = viewModel.photos[indexPath.item]
        let imageString = "https://farm\(currentImage.farm ?? 0).static.flickr.com/\(currentImage.server ?? "")/\(currentImage.id ?? "")_\(currentImage.secret ?? "").jpg"
        cell.imageURLString = imageString
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 20
        let height = collectionView.bounds.height / 3 - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
