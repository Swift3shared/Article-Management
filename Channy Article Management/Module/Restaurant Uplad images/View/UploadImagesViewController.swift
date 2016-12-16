//
//  UploadImagesViewController.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class UploadImagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init(nibName name: String?, bundle: Bundle?) {
        super.init(nibName: name, bundle: bundle)
        
        navigationItem.title = "Article"
        
        UploadImagesModel().uploads()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UploadImagesViewController.donePressed))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func donePressed(){
        
    }
}

extension UploadImagesViewController {
    
    
}
