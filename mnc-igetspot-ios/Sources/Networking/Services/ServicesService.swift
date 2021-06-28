////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class ServicesService: IGSService {
    
    func requestAllServicesCategory(limit:String? = nil, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        var parameters = [String:Any]()
        if let limitPerRequest = limit {
            parameters["limit"] = limitPerRequest
        }
        
        self.request(httppMethod: .get, pathUrl: "services",parameters:parameters, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestFeaturedServicesCategory(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "services/featured", isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestCategoryMaster(parameters:[String:String]?, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        var params: [String: Any]?
        if let userId = TokenManager.shared.getUserId() {
            params = parameters
            params?["userID"] = userId
        } else {
            params = parameters
        }
        
        self.request(httppMethod: .get, pathUrl: "services/category/master", parameters: params, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestCategoryPackage(parameters:[String:String]?, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        var params: [String: Any]?
        if let userId = TokenManager.shared.getUserId() {
            params = parameters
            params?["userID"] = userId
        } else {
            params = parameters
        }
        
        self.request(httppMethod: .get, pathUrl: "services/category/package", parameters: params, isAuthenticated: false, success: success, failure: failure)
    }
}
