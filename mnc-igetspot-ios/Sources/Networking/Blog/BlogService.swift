////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class BlogService: IGSService {

    func requestArchivedBlogs(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "whatson", isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestBlogDetail(blogId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "whatson/detail/\(blogId)"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
    }
    
    func requestBlogList(search:String? = nil, limit:Int? = nil, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        var parameters = [String:Any]()
        
        if let limitPerRequest = limit {
            parameters["limit"] = limitPerRequest
        }
        let pathUrl = "whatson"
        self.request(httppMethod: .get, pathUrl: pathUrl, parameters:parameters, isAuthenticated: false, success: success, failure: failure)
        
//        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: false, success: success, failure: failure)
    }

}
