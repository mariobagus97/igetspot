//
//  BlockReportService.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 10/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

class BlockReportService: IGSService {
    func reportUser(userId: String, title: String, desc: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let params = ["user_id": userId,
                      "title": title,
                      "description": desc]
        
        let pathUrl = "report/user"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: params, success: success, failure: failure)
    }
    
    func reportPackage(packageId: String, title: String, desc: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let params = ["package_id": packageId,
                      "title": title,
                      "description": desc]
        
        let pathUrl = "report/package"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: params, success: success, failure: failure)
    }
    
    func blockUser(userId: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let pathUrl = "report/block/\(userId)"
        self.request(httppMethod: .post, pathUrl: pathUrl, success: success, failure: failure)
    }
}
