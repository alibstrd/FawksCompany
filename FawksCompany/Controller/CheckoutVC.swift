//
//  CheckoutVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMtdBtn: UIButton!
    @IBOutlet weak var shippingMtdBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingHandlingLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func placeOrderBtnTapped(_ sender: Any) {
    }
    
    @IBAction func paymentMtnBtnTapped(_ sender: Any) {
    }
    
    @IBAction func shippingMtdBtnTapped(_ sender: Any) {
    }
    
}
