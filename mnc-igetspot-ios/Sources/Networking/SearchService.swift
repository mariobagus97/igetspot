//
//  SearchService.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class SearchService: IGSService {
    
    func requestSearch(keyword: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let param = ["p": keyword.lowercased()]
        
        self.request(httppMethod: .get, pathUrl: "search",parameters: param, success: success, failure: failure)
    }
    
    func searchPackageInMaster(masterId: String, package: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "masters/packages?masterID=\(masterId)&search=\(package.lowercased())", success: success, failure: failure)
    }
}
