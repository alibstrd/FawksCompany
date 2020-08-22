//
//  ViewController.swift
//  FawksCompany
//
//  Created by PHANTOM on 04/07/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    // to control the listener quota
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setCollectionView()
        setupAnonymousUser()
        setCategoriesListener()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        guard let font = UIFont(name: "futura", size: 20) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        spinner.startAnimating()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.remove()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner.stopAnimating()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutBtn.title = "Login"
        }
        
    }
    
    private func setupAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                }
            }
        }
    }
    
    func setCollectionView() {
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
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
                UserService.logoutUser()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.ProductVC {
            if let destinationVC = segue.destination as? ProductVC {
                destinationVC.category = selectedCategory
            }
        } else if segue.identifier == Segue.ToFavorites {
            if let destinationVC = segue.destination as? ProductVC {
                destinationVC.category = selectedCategory
                destinationVC.showFavorites = true
            }
        }
    }
    
    @IBAction func favoritesBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: Segue.ToFavorites, sender: self)
    }
    
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setCategoriesListener() {
           listener = db.categoriesQuery.addSnapshotListener({ (snap, error) in
               
               if let error = error {
                   debugPrint(error.localizedDescription)
                   return
               }
               
               snap?.documentChanges.forEach({ (change) in
                   
                   let data = change.document.data()
                   let category = Category.init(data: data)
                   
                   switch change.type {
                   case .added:
                       self.onDocumentAdded(change: change, category: category)
                   case .modified:
                       self.onDocumentModified(change: change, category: category)
                   case .removed:
                       self.onDocumentRemoved(change: change, category: category)
                   }
               })
           })
       }
    
    private func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    private func onDocumentModified(change: DocumentChange,category: Category) {
        // item changed, but remain at the sampe position
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            categories.insert(category, at: index)
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            // item changed, and changed position
            let newIndex = Int(change.newIndex)
            let oldIndex = Int(change.oldIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    private func onDocumentRemoved(change: DocumentChange, category: Category) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segue.ProductVC, sender: self)
    }
}



// This method is basically just for prior knowledge

//private func fetchDocument() {
//    let docRef = db.collection("categories").document("ZsLLvAEaB18ho7kJRz6g")
//
//    // to listen to real time data changes
//    listener = docRef.addSnapshotListener { (snap, error) in
//        guard let data = snap?.data() else { return }
//        // to avoid create multiple documents
//        self.categories.removeAll()
//        let category = Category.init(data: data)
//        self.categories.append(category)
//        self.collectionView.reloadData()
//    }
//}
//
//private func fetchCollection() {
//    let collectionRef = db.collection("categories")
//
//    // to listen to real time data changes
//    listener = collectionRef.addSnapshotListener { (snap, error) in
//        guard let documents = snap?.documents else { return }
//        self.categories.removeAll()
//        for document in documents {
//            let data = document.data()
//            let category = Category.init(data: data)
//            self.categories.append(category)
//        }
//        self.collectionView.reloadData()
//    }
//}
