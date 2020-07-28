//
//  Firebase+Utils.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

extension Firestore {
    var categoriesQuery: Query {
        return collection("categories").order(by: "time", descending: true)
    }
    
    func productQuery(categoryId: String) -> Query {
        return collection("products").order(by: "time", descending: true).whereField("category", isEqualTo: categoryId)
    }
}

extension Auth {
    func handleFireAuthError(error: Error, vc: UIViewController) {
           if let errorCode = AuthErrorCode(rawValue: error._code) {
               let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
               alert.addAction(okAction)
               vc.present(alert, animated: true, completion: nil)
           }
       }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already use, please use another account."
        case .userNotFound:
            return "Account not found for the specified user, please check and try again."
        case .userDisabled:
            return "Your account is already disabled, please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email."
        case .networkError:
            return "Network error, please try again."
        case .weakPassword:
            return "Your password is weak. The password must be 6 characters long."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
}
