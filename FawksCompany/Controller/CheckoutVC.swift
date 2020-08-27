//
//  CheckoutVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 23/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

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
    
    private var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
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
        paymentContext.paymentAmount = StripeCart.total
       }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    @IBAction func placeOrderBtnTapped(_ sender: Any) {
        paymentContext.requestPayment()
        spinner.startAnimating()
    }
    
    @IBAction func paymentMtnBtnTapped(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMtdBtnTapped(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
}

// MARK: - Stripe Payment Context Delegate
extension CheckoutVC: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Updating the selected payment method
        if let paymentMtd = paymentContext.selectedPaymentOption {
            paymentMtdBtn.setTitle(paymentMtd.label, for: .normal)
        } else {
            paymentMtdBtn.setTitle("Select Method", for: .normal)
        }
        
        // Updating the selected shipping method
        if let shippingMtd = paymentContext.selectedShippingMethod {
            shippingMtdBtn.setTitle(shippingMtd.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMtd.amount) * 100)
            setupPaymentInfo()
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        spinner.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data: [String:Any] = [
            "total_amount": StripeCart.total,
            "customer_id": UserService.user.stripeId,
            "payment_method_id": paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency": idempotency
        ]
        
        Functions.functions().httpsCallable("makeCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error)
                self.simpleAlert(title: "Error", msg: "Unable to make charge")
                completion(STPPaymentStatus.error ,error)
                return
            }
            
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setupPaymentInfo()
            completion(.success, nil)
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        
        spinner.stopAnimating()
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Thank you for your purchase"
        case .userCancellation:
            return
        @unknown default:
            fatalError()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        // Create the logistic service
        let anterAja = PKShippingMethod()
        anterAja.amount = 0
        anterAja.label = "AnterAja"
        anterAja.detail = "Arrives in 2-3 days"
        anterAja.identifier = "anter_aja"
        
        let jne = PKShippingMethod()
        jne.amount = 3.99
        jne.label = "JNE"
        jne.detail = "Arrives tomorrow"
        jne.identifier = "jne"
        
        if address.country == "ID" {
            completion(.valid, nil, [anterAja, jne], jne)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    
}


// MARK: - Table View Delegate & Data Source
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
