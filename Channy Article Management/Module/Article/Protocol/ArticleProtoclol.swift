//
//  ArticleProtoclol.swift
//  Channy Article Management
//
//  Created by iMac on 12/15/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

@objc protocol ArticlePresenterDelegate : NSObjectProtocol {
    
    // start up application
    @objc optional func setStartLoading()
    @objc optional func setFinishLoading()
    @objc optional func setEmptyView()
    @objc optional func setArticleList(_ articles : Array<Article>)
    @objc optional func reloadArticleListTable()
    
    // loading
    @objc optional func startLoading()
    @objc optional func finishLoading()
    
    // next page
    @objc optional func updateArticleList(_ articles : Array<Article>)
    
    // Create
    @objc optional func setCreateCompleted(_ article : Article)
    @objc optional func setCreateFailed()
    
    // Delete
    @objc optional func setDeleteCompleted(atIndexPath indextPath : IndexPath)
    @objc optional func setDeleteFailed(_ index:Int)
    
    // Upldate
    @objc optional func setUpdateCompleted(_ article : Article)
    @objc optional func setUpdateFailed()
}
