//
//  UploadConfiguration.swift
//  Channy Article Management
//
//  Created by iMac on 12/16/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import Foundation

/////////////////////
// Header field    //
/////////////////////
func uploadsHeaderFields(_ boundary : String) -> [String : String] {
    return [
        "Authorization" : "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
        "Content-Type"  : "multipart/form-data; boundary=\(boundary)",
    ]
}


//////////////////////
// URL              //
//////////////////////
let URL_UPLOADS = "http://120.136.24.174:15020/v1/api/admin/upload/multiple"

typealias UploadSuccessHandler = () -> ()
typealias UploadErrorHandler = () -> ()
