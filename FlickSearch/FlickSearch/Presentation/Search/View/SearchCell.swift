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
    
    var imageURLString: String? {
        didSet {
            guard let imageURL = URL(string: imageURLString ?? "") else {
                return
            }
            searchImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        searchImageView.image = nil
    }

}
