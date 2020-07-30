//
//  Category.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var time: Timestamp
    
    init(name: String, id: String, imgUrl: String, isActive: Bool = true, time: Timestamp) {
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
        self.isActive = isActive
        self.time = time
    }
    
    init(data: [String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.time = data["time"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(category: Category) -> [String:Any] {
        let data: [String:Any] = [
            "name" : category.name,
            "id" : category.id,
            "imgUrl" : category.imgUrl,
            "isActive" : category.isActive,
            "time" : category.time
        ]
        return data
    }
}
