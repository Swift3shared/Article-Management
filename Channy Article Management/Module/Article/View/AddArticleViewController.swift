//
//  AddArticleViewController.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class AddArticleViewController: UIViewController {
    
    // initialize components
    var titleTextField : UITextField?
    var descriptionTextView : UITextView?

    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)
        
        navigationItem.title = "New Article"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // Add components
        let screenHieght = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        titleTextField = ArticleUITextField(frame: CGRect(x: 20, y: screenHieght - (screenHieght - (100)), width: screenWidth - 40, height: 40), "Title")
        
        descriptionTextView = ArticleUITextView(frame: CGRect(x: 20, y: screenHieght - (screenHieght - (150)), width: screenWidth - 40, height: 70))
        
        descriptionTextView?.text = "Description"
        descriptionTextView?.textColor = UIColor.lightGray
        
        self.view.addSubview(titleTextField!)
        self.view.addSubview(descriptionTextView!)
        
        //self.view.addSubview(descriptionTextField!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
