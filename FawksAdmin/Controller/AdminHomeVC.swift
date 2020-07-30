//
//  ViewController.swift
//  FawksAdmin
//
//  Created by PHANTOM on 04/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        setupNavigationBar()
    }
    
    private func setupBarButton(){
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        
        let rightBar = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc func addCategory(){
        performSegue(withIdentifier: Segue.ToAddEditCategory, sender: self)
    }
    
    private func setupNavigationBar() {
           guard let font = UIFont(name: "futura", size: 18) else { return }
           navigationController?.navigationBar.titleTextAttributes = [
               NSAttributedString.Key.foregroundColor: UIColor.white,
               NSAttributedString.Key.font: font
           ]
       }


}

