//
//  StaticPageServices.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class StaticPageServices: IGSService {
    
    func requestPage(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "static"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
        
    }
}

