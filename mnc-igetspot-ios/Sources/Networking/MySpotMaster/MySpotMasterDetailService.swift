////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotMasterDetailService: IGSService {
    
    func requestMySpotDetail(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        self.request(httppMethod: .get, pathUrl: "spot", isAuthenticated: true, success: success, failure: failure)
    }
    
    func requestMySpotAbout(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "spot/about"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: true, success: success, failure: failure)
    }
    
    func requestMySpotServices(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "spot/services"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: true, success: success, failure: failure)
    }
    
    func requestMySpotPackages(masterId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "spot/packages"
        self.request(httppMethod: .get, pathUrl: pathUrl, isAuthenticated: true, success: success, failure: failure)
    }
    
    func requestMySpotPackageDetail(packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
                
        self.request(httppMethod: .get, pathUrl: "spot/packages/\(packageId)", success: success, failure: failure)
    }
    
    func requestMySpotRatingAndReview(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "spot/review"
        self.request(httppMethod: .get, pathUrl: pathUrl, success: success, failure: failure)
    }
    
}
