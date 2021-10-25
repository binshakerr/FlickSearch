//
//  UIViewController+Extensions.swift
//  FlickSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit

extension UIViewController {
    
    func showSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
