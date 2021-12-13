//
//  UIViewController+Alert.swift
//  GBMCodeChallenge
//
//  Created by Armand on 11/12/21.
//

import UIKit

extension UIViewController {
    
    func presentAlert(with message: String, action: (() -> ())? = nil ) {
        let alert = UIAlertController(title: "GBM Code Challenge", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
            action?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
