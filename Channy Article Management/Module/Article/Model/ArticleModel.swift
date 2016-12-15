//
//  ArticleModel.swift
//  Channy-Resturant-MVP-Homework
//
//  Created by sok channy on 12/12/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

var url:URL?
var urlRequest:URLRequest?
var session:URLSession?

class ArticleModel{
    ///////////////////
    //   Create     ///
    ///////////////////
    func create(_ article : Article, _ image : UIImage, success : @escaping SuccessHandler, error : @escaping ErrorHandler){
        
        uploadImage(image, successHandle: { image_url in
            let url = URL(string : URL_CREATE_ARTICLE)
            var httpRequest = URLRequest(url:url!)
            
            httpRequest.allHTTPHeaderFields = createHeaderField
            httpRequest.httpMethod = "POST"
            
            article.image = image_url
            
            let paramater = createArticleParamater(article)
            
            let dataParamater = try! JSONSerialization.data(withJSONObject: paramater, options: [])
            httpRequest.httpBody = dataParamater
            let session = URLSession.shared
            
            print("reach")
            
            session.dataTask(with: httpRequest){
                responseBody, response, errorResponse in
                let httpResponse = response as! HTTPURLResponse
                print("****** \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    success()
                }else{
                    error()
                }
            }.resume()
            
        }, errorHandle: {
            error()
        })
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
                    articles?.append(article)
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
    
    func uploadImage(_ image : UIImage , successHandle : @escaping SuccessHandlerWithString, errorHandle : @escaping ErrorHandler){
        let url = URL(string: URL_UPLOAD_SINGLE_IMAGE)
        var request = URLRequest(url: url!)
        let boundary = ImageToMultiPartFormData.generateBoundaryString()
        request.allHTTPHeaderFields = uploadHeaderField(boundary)
        request.httpMethod = "POST"
        
        let body = NSMutableData()
        let fname = ".jpg"
        
        body.append(ImageToMultiPartFormData.getBody("FILE", fname, image, boundary))
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                
        request.httpBody = body as Data
        
        let data = body as Data
        
        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: data) {
            data, response, error in
            guard let data = data, error == nil else {
                if let error = error as? NSError{
                    print(error)
                }
                errorHandle()
                return
            }            
            let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
            successHandle(jsonData["DATA"]!)
        }
        task.resume()
    }
}

