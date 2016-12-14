//
//  ArticleListPresenter.swift
//  Channy Article Management
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

class ArticleListPresenter {
    
    weak fileprivate var delegate:ArticleListPresenterDelegate?
    fileprivate var articleModel:ArticleModel?
    
    var attachToDelegate:ArticleListPresenterDelegate? = nil{
        didSet{
            delegate = attachToDelegate
        }
    }
    
    
    ///////////////////
    //   Create     ///
    ///////////////////
    func create(_ article : Article) {
        
    }
    
    ///////////////////
    // Get Article  ///
    ///////////////////
    func getArticle(_ page:Int,_ numberOfRow:Int){
        
        articleModel = ArticleModel()
        
        
        if page > 1 {
            self.delegate?.startLoading!()
        }
        else{
            self.delegate?.setStartLoading!()
        }
        
        articleModel?.getArticle(page, numberOfRow, completionHandler: {
            data in
            if let articles = data{
                // if page bigger than 0 and number of array more that 0 need update array else set use array
                if page > 1 {
                    self.delegate?.finishLoading!()
                    self.delegate?.updateArticleList!(articles)
                }else{
                    
                    self.delegate?.setFinishLoading!()
                    if articles.count > 0 {
                        self.delegate?.setArticleList!(articles)
                    }
                    else{
                        self.delegate?.setEmptyView!()
                    }
                }
            }
        })
    }
    
    /////////////////
    /// Delete   ////
    ///////////////
    /////////////////
    func deleteArticle(aritcleId:Int, index:Int) {
        delegate?.startLoading!()
        articleModel?.delete(aritcleId, success: {
            self.delegate?.finishLoading!()
            self.delegate?.setDeleteCompleted!(index)
        }, error: {
            self.delegate?.finishLoading!()
            self.delegate?.setDeleteFailed!(index)
        })
    }
    
    /////////////////
    /// Update //////
    /////////////////
    
    func update(_ article:Article) {
        
    }
}

@objc protocol ArticleListPresenterDelegate:NSObjectProtocol {
    
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
    @objc optional func setCreateCompleted()
    @objc optional func setCreateFailed()
    
    // Delete
    @objc optional func setDeleteCompleted(_ index:Int)
    @objc optional func setDeleteFailed(_ index:Int)
    
    // Upldate
    @objc optional func setUpdateCompleted()
    @objc optional func setUpdateFailed()
}
