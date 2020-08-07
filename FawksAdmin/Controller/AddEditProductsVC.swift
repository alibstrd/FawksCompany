//
//  AddEditProductsVC.swift
//  FawksAdmin
//
//  Created by PHANTOM on 07/08/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addProductBtn: RoundedShadowButton!
    
    
    // Variables
    var selectedCategory: Category!
    var productToEdit: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tappingImg()
        if let productToEdit = productToEdit {
            productNameTxt.text = productToEdit.name
            productPriceTxt.text = String(format: "%0.0f", productToEdit.price)
            productDescTxt.text = productToEdit.productDescription
            addProductBtn.setTitle("Save Changes", for: .normal)
            if let url = URL(string: productToEdit.imgUrl) {
                productImgView.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func addProductBtnPressed(_ sender: Any) {
        
    }
    
    private func tappingImg(){
        productImgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImgView.addGestureRecognizer(tap)
    }
    
    @objc func imgTapped(){
        launchImgPicker()
    }
    
    private func uploadImageDocument() {
        guard let image = productImgView.image,
            let productName = productNameTxt.text, productName.isNotEmpty,
            let productDesc = productDescTxt.text, productDesc.isNotEmpty,
            let priceInDouble = Double(productDesc) else {
                simpleAlert(title: "Error", msg: "Please fill out the empty fields")
                return
        }
        
        // 1. Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // 2. Create an image storage reference -> A location in firestorage for it to be stored
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        
        // 3. Create a metadata, to make firestorage easier to detect the data type
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // 4. Upload the data to firestorage
        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload data")
                return
            }
            // 5. Once the data is uploaded, retrieve the download url
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve the url")
                    return
                }
                
                guard let url = url else { return }
                self.spinner.stopAnimating()
                // 6. Upload new category document to the firestore category collection
                self.uploadDocument(url: url.absoluteString, price: priceInDouble)
            }
        }
    }
    
    private func uploadDocument(url: String, price: Double) {
        var docRef: DocumentReference!
        var product = Product.init(name: productNameTxt.text!, id: "", category: selectedCategory.name, price: price, productDescription: productDescTxt.text, imgUrl: url, time: Timestamp(), stock: 2)
        
        if let productToEdit = productToEdit {
            // Editing product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // Add new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        // because firestore need data of type -> [String:Any], we have to convert category above to the that type
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload the data to products collection")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.spinner.stopAnimating()
    }
}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.image = image
        productImgView.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
