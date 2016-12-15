//
//  ArticlePresenter.swift
//  Channy Article Management
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticlePresenter {
    
    weak fileprivate var delegate:ArticlePresenterDelegate?
    fileprivate var articleModel:ArticleModel?
    
    init() {
        articleModel = ArticleModel()
    }
    
    var attachToDelegate:ArticlePresenterDelegate? = nil{
        didSet{
            delegate = attachToDelegate
        }
    }
    
    ///////////////////
    //   Create     ///
    ///////////////////
    func create(_ article : Article, _ image : UIImage ) {
        delegate?.startLoading!()
        articleModel?.create(article, image, success: {
            self.delegate?.finishLoading!()
            self.delegate?.setCreateCompleted!(article)
        }, error: {
            self.delegate?.finishLoading!()
            self.delegate?.setCreateFailed!()
        })
    }
    
    ///////////////////
    // Get Article  ///
    ///////////////////
    func getArticle(_ page:Int,_ numberOfRow:Int){
        
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
    func deleteArticle(aritcleId:Int, atIndexPath indextPath : IndexPath) {
        delegate?.startLoading!()
        articleModel?.delete(aritcleId, success: {
            self.delegate?.finishLoading!()
            self.delegate?.setDeleteCompleted!(atIndexPath: indextPath)
        }, error: {
            self.delegate?.finishLoading!()
            self.delegate?.setDeleteFailed!(indextPath.row)
        })
    }
    
    /////////////////
    /// Update //////
    /////////////////
    
    func update(_ article:Article) {
        
        delegate?.startLoading!()
        articleModel?.update(article, success: {
            self.delegate?.finishLoading!()
            self.delegate?.setUpdateCompleted!(article)
        }, error: {
            self.delegate?.setUpdateFailed!()
        })
    }
}


