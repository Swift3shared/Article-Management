//
//  ArticleProtoclol.swift
//  Channy Article Management
//
//  Created by iMac on 12/15/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

@objc protocol ArticleDeletage :  NSObjectProtocol {
    
    @objc optional func setArticleList(_ articles : Array<Article>)
    @objc optional func updateArticleList(_ articles : Array<Article>)
    @objc optional func setFinishRefresh()

    @objc optional func setUpdateCompleted(_ article : Article)
    @objc optional func setUpdateFailed(_ title : String, _ message : String)
    @objc optional func setCreateCompleted(_ article : Article)
    @objc optional func setCreateFailed(_ tilet : String, _ message : String)

    @objc optional func setDeleteCompleted(atIndexPath indextPath : IndexPath)
    @objc optional func setDeleteFailed(_ index:Int)
    
}

