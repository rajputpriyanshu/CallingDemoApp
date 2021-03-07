//
//  UIViewController+Ext.swift
//  CallingApp
//
//  Created by ATLOGYS on 07/03/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
