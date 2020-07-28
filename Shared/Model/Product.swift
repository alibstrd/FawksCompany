//
//  Product.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imgUrl: String
    var time: Timestamp
    var stock: Int
    
    init(data: [String : Any]){
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.time = data["time"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
}
