//
//  AddEditCategoryVC.swift
//  FawksAdmin
//
//  Created by PHANTOM on 29/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tappingImg()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        uploadImageTheDocument()
        spinner.startAnimating()
    }
    
    private func tappingImg() {
        categoryImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        categoryImg.addGestureRecognizer(tap)
    }
    
    @objc func imgTapped(){
        launchImgPicker()
    }
    
    private func uploadImageTheDocument(){
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out the empty field")
                return
        }
        
        // 1. Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        // 2. Create an image storage reference -> A location in firestorage for it to be stored
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        // 3. Create a metadat, to make firestorage easier to detect the data type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // 4. Upload the data to firestorage
        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload data")
                return
            }
            
            // 5. Once the data is uploaded, retrieve the download url
            imageRef.downloadURL { (url, error) in
                if let _ = error {
                    debugPrint("Unable to retrieve download url")
                    self.spinner.stopAnimating()
                    return
                }
                
                guard let url = url else { return }
                print(url)
                self.spinner.stopAnimating()
                
                // 6. Upload new category document to the firestore category collection
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
    }
    
    private func uploadDocument(url: String) {
        var docRef: DocumentReference!
        docRef = Firestore.firestore().collection("categories").document()
        let category = Category.init(name: nameTxt.text!, id: docRef.documentID, imgUrl: url, time: Timestamp())
        
        // because firestore need data of type -> [String:Any], we have to convert category above the the that type
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload to categories collection")
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

extension AddEditCategoryVC: UIImagePickerControllerDelegate{
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.image = image
        categoryImg.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
