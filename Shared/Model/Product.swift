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
    
    init(name: String, id: String, category: String, price: Double, productDescription: String, imgUrl: String, time: Timestamp, stock: Int) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imgUrl = imgUrl
        self.time = time
        self.stock = stock
    }
    
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
    
    static func modelToData(product: Product) -> [String:Any] {
        let data: [String:Any] = [
            "name": product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "imgUrl": product.imgUrl,
            "time": product.time,
            "stock": product.stock
        ]
        return data
    }
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
