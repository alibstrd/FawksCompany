//
//  LoginVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 06/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: CustomButton) {
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else { return }
        
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            guard error == nil else {
                print("Failed to sign in")
                return
            }
            
            strongSelf.spinner.stopAnimating()
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func anonymousButtonPressed(_ sender: CustomButton) {
    }
    
    @IBAction func forgotPassButtonPressed(_ sender: UIButton) {
    }
    
}
