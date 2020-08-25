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

        setupTableView()
        setupPaymentInfo()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    
    func setupPaymentInfo() {
        subtotalLbl.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLbl.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingHandlingLbl.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLbl.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func removeItemcart(item: Product) {
        StripeCart.removeItemFromCart(item: item)
        tableView.reloadData()
        setupPaymentInfo()
       }
    
    @IBAction func placeOrderBtnTapped(_ sender: Any) {
    }
    
    @IBAction func paymentMtnBtnTapped(_ sender: Any) {
    }
    
    @IBAction func shippingMtdBtnTapped(_ sender: Any) {
    }
    
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource, CartItemCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            
            cell.configureCell(product: StripeCart.cartItems[indexPath.row], delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
