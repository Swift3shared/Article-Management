//
//  UploadImageModel.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class UploadImagesModel{
    func uploads(){
        
        let url = URL(string: URL_UPLOADS)
        var request = URLRequest(url:url!)
        let boundary = ImageToMultiPartFormData.generateBoundaryString()
        
        request.allHTTPHeaderFields = uploadsHeaderFields(boundary)
        request.httpMethod = "POST"
        
        //let body = createBody(parameters: , boundary: boundary) as Data
        
        let body = ImageToMultiPartFormData.createBodies(parameters: ["name":"Sok Shop","files":[#imageLiteral(resourceName: "testImage"),#imageLiteral(resourceName: "thumnail")]], boundary: boundary)
        
        let session = URLSession.shared
        
        print("Reach 1")
        
        session.uploadTask(with: request as URLRequest, from : body){
            data, response, error in
            print("Reach 2")
            
            print(response ?? "NO response")
            if data != nil {
                let dataJson = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(dataJson)
            }
            
            if error != nil {
                print(error ?? "NO response")
            }
            }.resume()
    }
}
