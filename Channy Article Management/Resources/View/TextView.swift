//
//  TextView.swift
//  Channy Article Management
//
//  Created by sok channy on 12/13/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticleUITextView : UITextView{
    convenience init(frame:CGRect,s:String){
        self.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 0.0
        self.layer.backgroundColor = UIColor.brown.cgColor
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}
