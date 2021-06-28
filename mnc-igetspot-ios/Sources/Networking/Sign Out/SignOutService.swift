//
//  SignOutService.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/1/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class SignOutService: IGSService {
    
    func signOut(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "logout"
        self.request(httppMethod: .post, pathUrl: pathUrl, success: success, failure: failure)
    }
    
}
