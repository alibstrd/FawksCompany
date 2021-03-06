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
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
      }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            guard error == nil else {
                debugPrint(error?.localizedDescription as Any)
                Auth.auth().handleFireAuthError(error: error!, vc: strongSelf)
                strongSelf.spinner.stopAnimating()
                return
            }
            
            strongSelf.spinner.stopAnimating()
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func anonymousButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgotPassButtonPressed(_ sender: UIButton) {
        let modalVC = ForgotPasswordVC()
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
    }
    
}
