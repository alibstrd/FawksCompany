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

        setupNavigationBar()
        navigationItem.leftBarButtonItem?.isEnabled = false
        let categoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.setRightBarButton(categoryBtn, animated: true)
    }
    
    @objc func addCategory() {
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
