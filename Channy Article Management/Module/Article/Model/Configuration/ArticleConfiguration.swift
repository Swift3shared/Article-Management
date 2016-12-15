//
//  ArticleConfiguration.swift
//  Channy Article Management
//
//  Created by sok channy on 12/14/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation


///////////////////////
//   Header Field   ///
///////////////////////
let createHeaderField : [ String : String ] = [
    "Content-Type": "application/json", "Accept": "*/*", "Authorization":
    "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
]

let updateHeaderField : [ String : String ] = [
    "Content-Type": "application/json","Accept": "*/*",
    "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
]

let getHeaderField  : [ String : String ] = [
    "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
    "Accept": "*/*"
]


let deleteHeaderField : [ String : String ] = [
    "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
    "Accept":"*/*"
]

/////////////////////////
//  URL                //
/////////////////////////
let URL_GET_ARTICLE = "http://120.136.24.174:1301/v1/api/articles?" // + page and limite
let URL_CREATE_ARTICLE = "http://120.136.24.174:1301/v1/api/articles"
let URL_UPDATE_ARTICLE = "http://120.136.24.174:1301/v1/api/articles/" // + article id
let URL_DELETE_ARTICLE = "http://120.136.24.174:1301/v1/api/articles/" // + article id

//////////////////////////
//     Typealias        //
//////////////////////////
typealias CompletionHandler = (Array<Article>?) -> ()
typealias SuccessHandler = () -> ()
typealias ErrorHandler = () -> ()


//////////////////////////
//      Paramater       //
//////////////////////////

func createArticleParamater(_ article : Article) -> AnyObject {
    return [
        "TITLE": "\(article.title)",
        "DESCRIPTION": "\(article.articleDescription)",
        "AUTHOR": 0,
        "CATEGORY_ID": 0,
        "STATUS": "string",
        "IMAGE": "string"
        ] as AnyObject
}

func updateArticleParamater(_ article : Article) -> AnyObject {
    return [
        "TITLE": article.title!,
        "DESCRIPTION": article.articleDescription!,
        "AUTHOR": 0,
        "CATEGORY_ID": 0,
        "STATUS": "string",
        "IMAGE": article.image!
        ] as AnyObject
}
