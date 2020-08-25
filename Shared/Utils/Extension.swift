//
//  Extension.swift
//  FawksCompany
//
//  Created by PHANTOM on 06/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}


extension UIViewController {
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension Int {
    
    func penniesToFormattedCurrency() -> String {
        // if this function being called on int is 1234
        // dollars = 1234 / 100 = $12.34
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let priceInDollars = formatter.string(from: dollars as NSNumber) {
            return priceInDollars
        }
        return "$0.00"
    }
}

