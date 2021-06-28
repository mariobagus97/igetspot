////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class MasterService: IGSService {
    
    func requestMasterDetail(userId:String, masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["userID":userId,
                          "masterID":masterId]
        
        self.request(httppMethod: .get, pathUrl: "masters/detail", parameters: parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestMasterPackageDetail(userId:String, masterId:String, packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["userID":userId,
                          "masterID":masterId,
                          "packageID":packageId]
        
        print("parameters :\(parameters) ")
        

        self.request(httppMethod: .get, pathUrl: "masters/packages/detail", parameters: parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestMasterPackages(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["masterID":masterId]
        self.request(httppMethod: .get, pathUrl: "masters/packages",parameters:parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestMasterServices(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "masters/services/\(masterId)"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestMasterRatingAndReview(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "masters/preview/\(masterId)"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestMasterAll(withPage page:Int, search:String, limit:Int, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        var parameters:[String:Any] = ["page":page,
                                       "limit":limit]
        if (search.isEmptyOrWhitespace() == false) {
            parameters["search"] = search
        }
        if let userId = TokenManager.shared.getUserId() {
            parameters["userID"] = userId
        }
        
        self.request(httppMethod: .get, pathUrl: "masters", parameters: parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestAllMasterOfTheWeek(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        var parameters = ["userID": ""]
        if let userId = TokenManager.shared.getUserId() {
            parameters["userID"] = userId
        }
        
        self.request(httppMethod: .get, pathUrl: "masters/toplist", parameters: parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func listBlockedMaster(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        self.request(httppMethod: .get, pathUrl: "report/block/list", isAuthenticated: true, success: success, failure: failure)
    }
    
    func unblockMaster(masterID:String,success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        self.request(httppMethod: .post, pathUrl: "report/unblock/\(masterID)", isAuthenticated: true, success: success, failure: failure)
    }
    
    
}
