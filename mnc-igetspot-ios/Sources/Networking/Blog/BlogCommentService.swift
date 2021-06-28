//
//  BlogCommentService.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class BlogCommentService: IGSService {
    
    func requestCommentList(blogId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "whatson/detail/\(blogId)"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
    }
    
}
