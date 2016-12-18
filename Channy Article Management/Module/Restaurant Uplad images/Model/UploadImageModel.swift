//
//  UploadImageModel.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class UploadImagesModel : NSObject{
    
    var session : URLSession!
    
    var uploadModelDelegate : UploadModelDelegate!
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func attachDelegate(_ uploadModelDelegate : UploadModelDelegate) {
        self.uploadModelDelegate = uploadModelDelegate
    }
    
    func uploads(_ restaurantName : String, _ imags : [UIImage]){
        
        let url = URL(string: URL_UPLOADS)
        var request = URLRequest(url : url!)
        let boundary = ImageToMultiPartFormData.generateBoundaryString()
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = uploadsHeaderFields(boundary)
        let body = ImageToMultiPartFormData.createBodies(parameters: ["name": restaurantName, "files": imags], boundary: boundary)
        
        session.uploadTask(with: request as URLRequest, from : body){
            data, response, err in
                        
            if data != nil {                                
                DispatchQueue.main.async {
                    self.uploadModelDelegate.setUploadsCompleted()
                }
            }
            
            if err != nil {
                DispatchQueue.main.async {
                    self.uploadModelDelegate.setUploadsFailed()
                }
            }
        }.resume()
    }
}

extension UploadImagesModel : URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let byte = ByteCountFormatter.string(fromByteCount: totalBytesSent, countStyle: .binary)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToSend, countStyle: .binary)        
        let display = String.init(format: "Upload %@ of %@", byte, totalSize)
        
        DispatchQueue.main.async {
            self.uploadModelDelegate.setUploadProgress(display)
        }
    }
}
