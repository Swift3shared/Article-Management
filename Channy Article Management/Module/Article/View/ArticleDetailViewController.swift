//
//  AddArticleViewController.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker:UIImagePickerController?
    
    var titleTextField : UITextField?
    var descriptionTextView : UITextView?
    var galaryButton : UIButton?
    var articleImage : UIImageView?
    var imagView : UIImage!
    
    var articleToUpdate : Article?
    var indexPathToUpdate : IndexPath?
    
    var artileListViewController:ArticleListViewController?
    
    var articlePresenter : ArticlePresenter?

    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)
        navigationItem.title = "New Article"
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
        imagePicker?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doneButtonPressed(_ sender : UIButton){
        if articleToUpdate == nil {
            let article = Article(id: 0, title: (titleTextField?.text!)!, description: (descriptionTextView?.text!)!, image: "Not avaliable")
            articlePresenter?.create(article, imagView)
        } else {
            self.articleToUpdate?.title = titleTextField?.text!
            self.articleToUpdate?.articleDescription = descriptionTextView?.text!
            self.articlePresenter?.update(self.articleToUpdate!)
        }
        
    }
    
    func openGallary()
    {
        imagePicker?.allowsEditing = false
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("reac")
            self.imagView = img
            self.articleImage!.image = self.imagView
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}

////////////////////////////////////
// Delegate                     ////
////////////////////////////////////
extension ArticleDetailViewController : ArticlePresenterDelegate {
    
    func startLoading() {
        print("Start Create")
    }
    
    func finishLoading() {
        print("Finish Create")
    }
    
    func setCreateCompleted(_ article:Article) {
        self.artileListViewController?.setCreateCompleted(article)
    }
    
    func setCreateFailed() {
        print("Create failed")
    }
    
    func setUpdateCompleted(_ article: Article) {
        self.artileListViewController?.updateArticle(atIndexParth: indexPathToUpdate!, article: article)
    }
    
}

/////////////////////////////////////////////
//  Add component into view                 /
/////////////////////////////////////////////
extension ArticleDetailViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        
        let screenHieght = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        articleImage = UIImageView(frame : CGRect(x: 20, y: 80, width: screenWidth - 40 , height: screenHieght / 2 - 100 ))
        
        
        titleTextField = ArticleUITextField(frame: CGRect(x: 20, y: screenHieght / 2 + 10 , width: screenWidth - 40, height: 40), "Title")
        
        descriptionTextView = ArticleUITextView(frame: CGRect(x: 20, y: screenHieght / 2 + 70, width: screenWidth - 40, height: 70))
        
        descriptionTextView?.text = "Description"
        descriptionTextView?.textColor = UIColor.lightGray
        
        galaryButton = UIButton(frame : CGRect(x: (screenWidth / 2) - 50, y: screenHieght - 100 , width: 100, height: 50))
        galaryButton?.titleLabel?.text = "Save"
        galaryButton?.titleLabel?.textColor = UIColor.blue
        galaryButton?.layer.borderWidth = 1
        galaryButton?.layer.borderColor = UIColor.blue.cgColor
        
        titleTextField?.delegate = self
        descriptionTextView?.delegate = self
        
        self.view.addSubview(articleImage!)
        self.view.addSubview(galaryButton!)
        self.view.addSubview(titleTextField!)
        self.view.addSubview(descriptionTextView!)
        
        if articleToUpdate != nil {
            titleTextField?.text = articleToUpdate?.title
            descriptionTextView?.text = articleToUpdate?.articleDescription
            
            do {
                let url = URL(string: (articleToUpdate?.image)!)
                let data = try Data(contentsOf: url!)
                articleImage?.image = UIImage(data: data)
            }catch {}
        }
        
        galaryButton?.addTarget(self, action: #selector(openGallary), for: .touchDown)
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
        textView.text = ""
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = "Description"
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}






