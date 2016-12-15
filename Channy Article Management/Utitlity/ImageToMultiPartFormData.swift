//
//  ImageToMultiPartFormData.swift
//  Channy Article Management
//
//  Created by iMac on 12/15/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ImageToMultiPartFormData{
    
    /////////////////////////////////////////////////////////////
    /// Trnsform image to Multipart form data for single image //
    /////////////////////////////////////////////////////////////
    func getBody(_ paramater : String, _ fileName : String, _ image : UIImage, _ boundary : String) -> Data {
        
        let body = NSMutableData()
        let data = UIImageJPEGRepresentation(image,1);
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(paramater)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(data!)
        body.append("\r\n".data(using: .utf8)!)
        
        return body as Data
    }
    
    
    func createBody(parameters: NSMutableDictionary?,boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                if(value is String || value is NSString){
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    body.append("\(value)\r\n".data(using: .utf8)!)
                }
                    
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "image\(i).jpg"
                        body.append(getBody( key as! String, filename, image, boundary))
                        i = i + 1;
                    }
                }
            }
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    
}
