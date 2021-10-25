//
//  UIView+Extensions.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit

extension UIView {
    
    //corner radius for specific corners of a view
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    //make it a complete circle
    func makeRounded(){
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    
    func addShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}
