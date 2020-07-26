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
    
    init(data: [String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.time = data["time"] as? Timestamp ?? Timestamp()
    }
}
