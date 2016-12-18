//
//  UploadImagesViewController.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class UploadImagesViewController: UIViewController {
    
    var alarmCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var collectionView: UICollectionView!
    var restaurantNameTextField : UITextField!
    var progressLabel : UILabel!
    
    var uploadPresenter : UploadImagesPrester?
    
    var imags : [UIImage] = [#imageLiteral(resourceName: "image3"),#imageLiteral(resourceName: "image2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.uploadPresenter = UploadImagesPrester()
        self.uploadPresenter?.attachDelegate(self)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 20 , height: (UIScreen.main.bounds.height / 5) - 20)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 + 300) , collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView?.backgroundColor = UIColor.white
        self.view.addSubview(collectionView!)
        
        
        self.progressLabel = UILabel(frame: CGRect(x: 20, y: self.view.bounds.height - 150, width: UIScreen.main.bounds.width - 40, height: 50))
        self.progressLabel.text = "Progress"
        self.progressLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.progressLabel)
        
       
        self.restaurantNameTextField = UITextField(frame: CGRect(x: 20, y : self.view.bounds.height - 100, width: UIScreen.main.bounds.width - 40, height: 35))
        self.restaurantNameTextField?.placeholder = "Restaurant name"
        self.restaurantNameTextField?.layer.borderWidth = 1
        
        self.view.addSubview(self.restaurantNameTextField!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)
        
        navigationItem.title = "Uploads"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UploadImagesViewController.donePressed))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func donePressed(){
        self.uploadPresenter?.uploads((self.restaurantNameTextField?.text)! , imags)
    }
}

/////////////////////////// 
//...     Delegate      ...
///////////////////////////
extension UploadImagesViewController : UploadImagesPresterDelegate{
    
    func setUploadsFailed(_ title : String, _ message : String) {
        self.messageAlter(title, message)
    }
    
    func setUploadsCompleted() {
        self.messageAlter("Success", "You have uploded.")
        self.progressLabel.text = "Progress"
    }
    
    func setUploadProgress(_ message: String) {
        self.progressLabel.text = message
    }
    
    func messageAlter(_ title : String, _ message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


///////////////////////////
// Collection               .
///////////////////////////
extension UploadImagesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imags.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.orange
        cell.configuration(imags[indexPath.row])
        return cell
    }
    
}
