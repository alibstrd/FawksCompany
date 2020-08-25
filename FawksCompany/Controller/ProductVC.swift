//
//  ProductVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductVC: UIViewController, ProductCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var products = [Product]()
    var category: Category!
    var listener: ListenerRegistration!
    var db: Firestore!
    var showFavorites: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProductListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.remove()
        products.removeAll()
        tableView.reloadData()
    }
    
    func setProductListener() {
        
        var ref: Query!
        if showFavorites {
            ref = db.collection("user").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.productQuery(categoryId: category.id)
        }
        
        
        listener = ref.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change, product: product)
                }
            })
        })
    }
    
    func productFavorited(product: Product) {
        UserService.favoriteSelected(product: product)
//        guard let index = products.firstIndex(of: product) else { return }
//        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.reloadData()
      }
    
    func itemToCart(product: Product) {
        StripeCart.addItemToCart(item: product)
    }

}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        //tableView.reloadData()
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        // item changed. but remain at the same position
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadData()
        } else {
            let newIndex = Int(change.newIndex)
            let oldIndex = Int(change.oldIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange, product: Product) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .fade)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        productDetailVC.product = selectedProduct
        productDetailVC.modalTransitionStyle = .crossDissolve
        productDetailVC.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) {
            self.present(productDetailVC, animated: true, completion: nil)
        }
    }
}
