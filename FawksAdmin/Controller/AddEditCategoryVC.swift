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
    @IBOutlet weak var editBtn:  UIButton!
    
    var categoryToEdit: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tappingImg()
        // if we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            
            editBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func addCategory(_ sender: Any) {
        uploadImageThenDocument()
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
    
    private func uploadImageThenDocument(){
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out the empty field")
                return
        }
        
        // 1. Turn image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
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
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgUrl: url,
                                     time: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            // Editing category
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // Add new category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        // because firestore need data of type -> [String:Any], we have to convert category above to the that type
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
