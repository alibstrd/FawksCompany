//
//  AdminProductVC.swift
//  FawksCompany
//
//  Created by PHANTOM on 07/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

class AdminProductVC: ProductVC {
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let addProductButton = UIBarButtonItem(title: "Add Product", style: .plain, target: self, action: #selector(addProduct))
        navigationItem.setRightBarButtonItems([editCategoryButton, addProductButton], animated: true)
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segue.ToEditCategory, sender: self)
    }
    
    @objc func addProduct() {
        performSegue(withIdentifier: Segue.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segue.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.productToEdit = selectedProduct
                destination.selectedCategory = category
            }
        } else if segue.identifier == Segue.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
    

}
