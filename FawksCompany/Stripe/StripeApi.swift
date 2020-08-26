//
//  StripeApi.swift
//  FawksCompany
//
//  Created by PHANTOM on 26/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        // Data to pass to callable cloud functions
        let data: [String:Any] = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let key = result?.data as? [String:Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
        }
    }
    
}
