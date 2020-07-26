//
//  ProductVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var products = [Product]()
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let product = Product.init(name: "BMW X9", id: "ajsajd", category: "Motorsport", price: 1200000, productDescription: "Motorsport", imageUrl: "https://images.unsplash.com/photo-1541443131876-44b03de101c5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80", timestamp: Timestamp(), stock: 0, favorite: false)
        products.append(product)
        
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
