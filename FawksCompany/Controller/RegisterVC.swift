//
//  RegisterVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 06/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changin the matching image state when the pass & confirm match are typing
        // Because UITextField is inhireted from UIControl, it's possible to use the UIControl function for this need
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else { return }
        
        // If we have started typing in the confirm textfield
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPassTxt.text = ""
            }
        }
        
        // When the password match, the image appeared
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.Correct)
            confirmPassCheckImg.image = UIImage(named: AppImages.Correct)
        } else {
            passCheckImg.image = UIImage(named: AppImages.Wrong)
            confirmPassCheckImg.image = UIImage(named: AppImages.Wrong)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: CustomButton) {
        guard let username = userNameTxt.text, username.isNotEmpty,
            let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty,
            let confirmPassword = passwordTxt.text, confirmPassword.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confirmPassTxt.text, confirmPass == confirmPassword else {
            simpleAlert(title: "Error", msg: "Password does not match!")
            return
        }
        
        spinner.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        // create user with anonymous user credential (all the data including favorites,etc are collected with the new created user)
        authUser.link(with: credential) { (result, error) in
            self.spinner.stopAnimating()
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            guard let fireUser = result?.user else { return }
            let fawksUser = User.init(id: fireUser.uid, email: email, username: username, stripeId: "")
            // Upload document
            self.createFirestoreUser(user: fawksUser)
        }
    
    }
    
    func createFirestoreUser(user: User) {
        // 1. Create document reference
        let newUserRef = Firestore.firestore().collection("user").document(user.id)
        
        // 2. Create model data
        let data = User.modelToData(user: user)
        
        // 3. Upload to firestore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Unable to upload new user document to Firestore")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
        }
    }
    
}
