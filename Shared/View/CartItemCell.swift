//
//  CartItemCell.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var deleteItemBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteItemBtnTapped(_ sender: Any) {
        
    }
    
}
