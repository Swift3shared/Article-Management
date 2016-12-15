//
//  Article.swift
//  Channy Article Management
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

class Article:NSObject {
    var id:Int?
    var title:String?
    var articleDescription:String?
    var image:String?
    
    init(id:Int,title:String,description:String,image:String) {
        self.id = id; self.title = title; self.articleDescription = description; self.image = image
    }
    
    override init() {}
    
    func map(_ object: [String:AnyObject]){
        if let id = object["ID"] {
            self.id = id as? Int
        }
        
        if let title = object["TITLE"] {
            self.title = title as? String
        }
        
        if let description = object["DESCRIPTION"] {
            self.articleDescription = description as? String
        }
        
        if let image = object["IMAGE"] {
            self.image = image as? String
        }
    }
}

