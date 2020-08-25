//
//  CartItemCell.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import Kingfisher

protocol CartItemCellDelegate: class {
    func removeItemcart(item: Product)
}

class CartItemCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var deleteItemBtn: UIButton!
    
    weak var delegate: CartItemCellDelegate?
    private var item: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(product: Product, delegate: CartItemCellDelegate) {
        self.item = product
        self.delegate = delegate
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLbl.text = "\(product.name) \(price)"
        }
    }
    
    @IBAction func deleteItemBtnTapped(_ sender: Any) {
        delegate?.removeItemcart(item: item)
    }
    
}
