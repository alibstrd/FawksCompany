//
//  ProductDetailVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 28/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailVC: UIViewController {
    
    var product: Product!

    @IBOutlet weak var pdImg: UIImageView!
    @IBOutlet weak var pdTitleLbl: UILabel!
    @IBOutlet weak var pdPriceLbl: UILabel!
    @IBOutlet weak var pdDesc: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var childView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdTitleLbl.text = product.name
        pdDesc.text = product.productDescription
        
        if let url = URL(string: product.imgUrl) {
            pdImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            pdPriceLbl.text = price
        }
        
        // Dismiss tapping outside of product detail view
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        childView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartBtnPressed(_ sender: Any) {
        StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepShoppingBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
