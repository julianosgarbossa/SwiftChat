//
//  UIViewController + Extension.swift
//  SwiftChat
//
//  Created by Juliano Sgarbossa on 28/09/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
