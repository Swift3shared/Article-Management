//
//  UploadImageProtocol.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

protocol UploadImagesPresterDelegate {  
    func setUploadProgress(_ message : String)
    func setUploadsCompleted()
    func setUploadsFailed(_ title : String, _ message : String)
}

protocol UploadModelDelegate {
    func setUploadProgress(_ message : String)
    func setUploadsCompleted()
    func setUploadsFailed()
}
