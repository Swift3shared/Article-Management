//
//  ArticleModel.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

var url:URL?
var urlRequest:URLRequest?
var session:URLSession?

class ArticleModel{
    ///////////////////
    //   Create     ///
    ///////////////////
    func create(_ article : Article, success : @escaping SuccessHandler, error : @escaping ErrorHandler){
        
        let url = URL(string : URL_CREATE_ARTICLE)
        var httpRequest = URLRequest(url:url!)
        
        httpRequest.allHTTPHeaderFields = createHeaderField
        httpRequest.httpMethod = "POST"
        
        let paramater = createArticleParamater(article)
        
        let dataParamater = try! JSONSerialization.data(withJSONObject: paramater, options: [])
        httpRequest.httpBody = dataParamater
        let session = URLSession.shared
        
        session.dataTask(with: httpRequest){
            responseBody, response, errorResponse in
                let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 201 {
                success()
            }else{
                error()
            }
        }.resume()
    }
    
    ///////////////////
    //  Get Article  //
    ///////////////////
    func getArticle(_ page:Int,_ numberOfRow:Int, completionHandler : @escaping CompletionHandler) {
        url = URL(string : "\(URL_GET_ARTICLE)page=\(page)&limit=\(numberOfRow)")
        urlRequest = URLRequest(url:url!)
        urlRequest?.httpMethod = "GET"
        urlRequest?.allHTTPHeaderFields = getHeaderField
        session = URLSession.shared
        
        session?.dataTask(with: urlRequest!, completionHandler:
        { data,resopnse,error in
            
            var articles:Array<Article>?
            
            if data != nil, error == nil{
                let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                let dictionaryData = dictionary["DATA"] as! [AnyObject]
                articles = Array<Article>()
                for value in dictionaryData {
                    let article = Article()
                    article.map(value as! [String : AnyObject])
                    articles?.insert(article, at: 0)
                }
            }
            completionHandler(articles)
        }).resume()
    }

    //////////////////////
    /// Delete Article ///
    //////////////////////
    func delete(_ articleId : Int, success : @escaping SuccessHandler, error : @escaping ErrorHandler) {
        
        let url = URL(string : "\(URL_DELETE_ARTICLE)\(articleId)" )
        var httpRequest = URLRequest(url:url!)
        httpRequest.httpMethod = "GET"
        httpRequest.allHTTPHeaderFields = deleteHeaderField
        let session = URLSession.shared
        session.dataTask(with: httpRequest, completionHandler: {
            data, response, err in
            if response != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    success()
                }else{
                    error()
                }
            }
        }).resume()
    }
    
    /////////////////////
    /// Update   ///////
    ///////////////////
    /////////////////
    func update(_ article : Article, success:@escaping SuccessHandler, error:@escaping ErrorHandler) {
        let url = URL(string:"\(URL_UPDATE_ARTICLE)\(article.id!)")
        var httpRequest = URLRequest(url:url!)
        
        httpRequest.allHTTPHeaderFields = updateHeaderField
        httpRequest.httpMethod = "PUT"
        
        let paramater = updateArticleParamater(article)
        
        let dataParamater = try! JSONSerialization.data(withJSONObject: paramater, options: [])
        httpRequest.httpBody = dataParamater
        let session = URLSession.shared
        
        session.dataTask(with: httpRequest){
            responseBody, response, errorResponse in
            
            if response != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    success()
                }else{
                    error()
                }
            }
        }.resume()
    }
}

