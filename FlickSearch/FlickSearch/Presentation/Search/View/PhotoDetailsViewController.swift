//
//  PhotoDetailsViewController.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit
import Kingfisher

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsImageView: UIImageView!
    
    private var item: PhotoItemViewModel!
        
    convenience init(photo: PhotoItemViewModel){
        self.init()
        self.item = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPhoto()
    }
    
    func setupUI() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    
    func loadPhoto(){
        detailsImageView.kf.indicatorType = .activity
        detailsImageView.kf.setImage(with: item.imageURL)
    }


}


extension PhotoDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailsImageView
    }
}
