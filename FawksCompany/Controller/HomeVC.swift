//
//  ViewController.swift
//  FawksCompany
//
//  Created by PHANTOM on 04/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {

    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.handleFireAuthError(error: error)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
        
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func loginOutBtnPressed(_ sender: UIBarButtonItem) {
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        if authUser.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
//                Auth.auth().signInAnonymously { (result, error) in
//                    if let error = error {
//                        debugPrint(error.localizedDescription)
//                    }
//
//                }
                self.presentLoginController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
//        if let _ = Auth.auth().currentUser {
//            // We are logged in
//            do {
//                try Auth.auth().signOut()
//                presentLoginController()
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
//        } else {
//            presentLoginController()
//        }
    }
    

}

