//
//  UploadImageProtocol.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

protocol UploadImagesPresterDelegate {
    func setStartUploads()
    func setFinishUploads()
    func setUploadsCompleted(_ urls : [String])
    func setUploadsFailed()
}
