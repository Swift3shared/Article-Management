//
//  UploadImagePresenter.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class UploadImagesPrester {
    
    var delegate : UploadImagesPresterDelegate?
    
    var uploadImagesModel : UploadImagesModel?
    
    init() {
        self.uploadImagesModel = UploadImagesModel()
        self.uploadImagesModel?.attachDelegate(self)
    }
    
    func attachDelegate(_ uploadImagesPresenterDelegate : UploadImagesPresterDelegate)  {
        self.delegate = uploadImagesPresenterDelegate
    }
    
    func uploads(_ restaurantName : String, _ images: [UIImage]){
        if restaurantName != "" && images.count > 0{
            self.uploadImagesModel?.uploads( restaurantName, images)
        }else if images.count == 0 {
            self.delegate?.setUploadsFailed("Missed", "image to upload is required.")
        }else{
            self.delegate?.setUploadsFailed("Missed", "Restaurant name is required.")
        }
        
    }
    
}

extension UploadImagesPrester : UploadModelDelegate {
    func setUploadsFailed() {
        self.delegate?.setUploadsFailed("Error", "Upload failed")
    }
    func setUploadsCompleted() {
        self.delegate?.setUploadsCompleted()
    }
    func setUploadProgress(_ message: String) {
        self.delegate?.setUploadProgress(message)
    }
}
