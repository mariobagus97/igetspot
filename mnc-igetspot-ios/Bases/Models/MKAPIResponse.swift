//
//  MKAPIResponse.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 20/12/17.
//  Copyright © 2017 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MKAPIResponse {
    var code: Int = 0
    var message: String = ""
    var data: JSON = JSON()
    
    static func with(json: JSON) -> MKAPIResponse {
        let apiResponse = MKAPIResponse()
        
        if json["code"].exists() {
            apiResponse.code = json["code"].intValue
        }
        
        if json["message"].exists() {
            apiResponse.message = json["message"].stringValue
        }
        
        if json["data"].exists() {
            apiResponse.data = json["data"]
        }
        
        return apiResponse
    }
    
    func isSuccess() -> Bool {
        return 200 <= code && code < 300
    }
}

