////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Alamofire

class MySpotMasterDetailEditService: IGSService {
    
    func requestEditAbout(contentString:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["about":contentString]
        
        self.request(httppMethod: .post, pathUrl: "spot/about", parameters: parameters, success: success, failure: failure)
    }
    
    func requestAddPackage(parameters:Parameters, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "spot/packages"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, encoding: ArrayEncoding() , success: success, failure: failure)
    }
    
    func requestEditPackageDetails(packageId:String, parameters:[String:Any]?, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        
        let pathUrl = "spot/packages/\(packageId)"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, encoding: Alamofire.JSONEncoding.default, success: success, failure: failure)
    }
    
    func requestDeletePackageDetails(packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        
        let pathUrl = "spot/packages/\(packageId)"
        self.request(httppMethod: .delete, pathUrl: pathUrl, parameters: nil, encoding: JSONEncoding.default , success: success, failure: failure)
    }
    
}
