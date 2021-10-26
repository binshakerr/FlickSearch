//
//  SearchCell.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var searchImageView: UIImageView!
    
    var imageURL: URL? {
        didSet {
            guard let imageURL = imageURL else {
                return
            }
            searchImageView.kf.indicatorType = .activity
            searchImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        searchImageView.image = nil
    }

}
