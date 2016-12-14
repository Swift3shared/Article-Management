//
//  TextField.swift
//  Channy Article Management
//
//  Created by sok channy on 12/13/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticleUITextField : UITextField {
    
    convenience init(frame: CGRect,_ placeHolder:String) {
        self.init(frame: frame)
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 1.0
        self.borderStyle = UITextBorderStyle.line
        self.placeholder = placeholder
    }
    
}

