//
//  ProductCell.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
    func itemToCart(product: Product)
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var product: Product!
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            // Favorite
            favoriteBtn.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            // Unfavorite
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
    }
    
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
        delegate?.productFavorited(product: product)
    }
    
    @IBAction func addToCartBtnPressed(_ sender: CustomButton) {
        delegate?.itemToCart(product: product)
    }
}
