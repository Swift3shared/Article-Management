//
//  ArticlePresenter.swift
//  Channy Article Management
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticlePresenter {
    
    weak fileprivate var delegate : ArticleDeletage?
    fileprivate var articleModel : ArticleModel?
    
    init() {
        articleModel = ArticleModel()
    }
    
    var attachToDelegate : ArticleDeletage? = nil{
        didSet{
            delegate = attachToDelegate
        }
    }
    
    ///////////////////
    //   Create     ///
    ///////////////////
    func create(_ article : Article, _ image : UIImage ) {
     
        if article.title == "" {
            delegate?.setCreateFailed!("Missed", "Article title is required.")
            return
        }
        
        if article.description == "" {
            delegate?.setCreateFailed!("Missed", "Article description is required.")
            return
        }
        
        
        if image == #imageLiteral(resourceName: "thumbnail"){
            delegate?.setCreateFailed!("Missed", "Article image is required.")
            return
        }
        articleModel?.create(article, image, success: { data in
            self.delegate?.setCreateCompleted!(data)
        }, error: {
            self.delegate?.setCreateFailed!("Error", "Create new article is failed.")
        })
    }
    
    ///////////////////
    // Get Article  ///
    ///////////////////
    func getArticle(_ page : Int,_ numberOfRow:Int){
        articleModel?.getArticle(page, numberOfRow, completionHandler: {
            data in
            if let articles = data{
                if page > 1 {
                    DispatchQueue.main.async {
                        self.delegate?.updateArticleList!(articles)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.delegate?.setFinishRefresh!()
                        self.delegate?.setArticleList!(articles)
                    }
                }
            }
        })
    }
    
    /////////////////
    /// Delete   ////
    ///////////////
    /////////////////
    func deleteArticle(_ artitcleId : Int, atIndexPath indextPath : IndexPath) {

        articleModel?.delete(artitcleId, success: {
            self.delegate?.setDeleteCompleted!(atIndexPath: indextPath)            
        }, error: {
            self.delegate?.setDeleteFailed!(indextPath.row)
        })
    }
    
    /////////////////
    /// Update //////
    /////////////////
    
    func update(_ article:Article, _ image : UIImage = #imageLiteral(resourceName: "thumbnail")) {

        if article.title == "" {
            delegate?.setUpdateFailed!("Missed", "Article title is required.")
            return
        }
        
        if article.description == "" {
            delegate?.setUpdateFailed!("Missed", "Article description is required.")
            return
        }
        
        articleModel?.update(article, image, success: {
            print("Presenter update ")
            self.delegate?.setUpdateCompleted!(article)
        }, error: {
            self.delegate?.setUpdateFailed!("Error", "This article cannot be update.")
        })
    }
}


