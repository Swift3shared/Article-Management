//
//  AddArticleViewController.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imagePicker:UIImagePickerController!
    
    var titleTextField : UITextField!
    var descriptionTextView : UITextView!
    var galaryButton : UIButton!
    var articleImage : UIImageView!
    var imagView : UIImage!
    
    var articleToUpdate : Article?
    var indexPathToUpdate : IndexPath?
    
    var artileListViewController:ArticleListViewController?
    
    var articlePresenter : ArticlePresenter?

    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.attachToDelegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doneButtonPressed(_ sender : UIButton){
        if articleToUpdate == nil {
            let article = Article(id: 0, title: titleTextField.text!, description: descriptionTextView.text!, image: "Not avaliable")
            if  self.imagView != nil {
                self.articlePresenter!.create(article, self.imagView)
            }
            else {
                self.messageAlter("Missed", "Please select an image.")
            }
            
        } else {
            self.articleToUpdate!.title = self.titleTextField.text!
            self.articleToUpdate!.articleDescription = self.descriptionTextView.text!
            if self.imagView != nil{
                self.articlePresenter!.update(self.articleToUpdate!, self.imagView)
            }else {
                self.articlePresenter!.update(self.articleToUpdate!)
            }            
        }
        
    }
    
    func openGallary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            DispatchQueue.main.async {
                self.articleImage.image = image
                self.imagView = image
            }
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DispatchQueue.main.async {
                self.articleImage.image = image
                self.imagView = image
            }
        } else {
            articleImage.image = nil
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

////////////////////////////////////
// Delegate                     ////
////////////////////////////////////
extension ArticleDetailViewController : ArticleDeletage {
    
    func setCreateCompleted(_ article:Article) {
        self.artileListViewController?.setCreateCompleted(article)
        self.messageAlter("Success", "Article is been create.")
    }
    
    
    func setCreateFailed(_ title : String, _ message : String) {
        self.messageAlter(title, message)
    }
    
    func setUpdateCompleted(_ article: Article) {
        self.messageAlter("Success", "Article is been update.")
        self.artileListViewController?.updateArticle(atIndexParth: self.indexPathToUpdate!, article: article)
    }
    
    func setUpdateFailed(_ title : String, _ message : String) {
        messageAlter(title, message)        
    }
    
    func messageAlter(_ title : String, _ message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

/////////////////////////////////////////////
//  Add component into view                 /
/////////////////////////////////////////////
extension ArticleDetailViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        
        let screenHieght = self.view.bounds.height
        let screenWidth = self.view.bounds.width
        
        self.galaryButton = UIButton(frame : CGRect(x: 20, y: 100, width: screenWidth - 40 , height: screenHieght / 2 - 100 ))
        self.articleImage = UIImageView(frame: self.galaryButton.bounds)
        self.galaryButton.layer.borderWidth = 2
        self.galaryButton.addSubview(self.articleImage)
        self.galaryButton.addTarget(self, action: #selector(openGallary), for: .touchDown)
        
        self.titleTextField = UITextField(frame: CGRect(x: 20, y: screenHieght / 2 + 10 , width: screenWidth - 40, height: 35))
        self.titleTextField.layer.borderWidth = 1
        self.titleTextField.placeholder = "Article title"
        
        self.descriptionTextView = UITextView(frame: CGRect(x: 20, y: screenHieght / 2 + 70, width: screenWidth - 40, height: 70))
        
        self.descriptionTextView.text = "Description"
        self.descriptionTextView.textColor = UIColor.black
        self.descriptionTextView.layer.borderWidth = 1
        
        self.titleTextField.delegate = self
        self.descriptionTextView.delegate = self
        
        self.view.addSubview(galaryButton)
        self.view.addSubview(titleTextField)
        self.view.addSubview(descriptionTextView)
        
        if articleToUpdate != nil {
            
            navigationItem.title = "Update"
            DispatchQueue.main.async {
            self.titleTextField?.text = self.articleToUpdate?.title
            self.descriptionTextView?.text = self.articleToUpdate?.articleDescription
            
            do {
                let url = URL(string: (self.articleToUpdate?.image)!) ?? URL(string : "http://120.136.24.174:1301/image-thumbnails/thumbnail-9350859e-6565-40f1-b5b3-7d1e0f859a73.jpg")
                let data = try Data(contentsOf: url!)
                self.articleImage.image = UIImage(data: data)
            }catch {}
            }
        }else {
            navigationItem.title = "New Article"
        }
    }
}

extension ArticleDetailViewController : UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""  {
            textView.text = "Description"
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}






