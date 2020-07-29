//
//  AddEditCategoryVC.swift
//  FawksAdmin
//
//  Created by PHANTOM on 29/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tappingImg()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        
    }
    
    func tappingImg() {
        categoryImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        categoryImg.addGestureRecognizer(tap)
    }
    
    @objc func imgTapped(){
        launchImgPicker()
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
