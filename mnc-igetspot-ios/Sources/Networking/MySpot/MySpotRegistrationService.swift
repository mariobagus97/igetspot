////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire

class MySpotRegistrationService: IGSService {
    
    func requestRegistrationMasterStepOne(masterName: String, describeWork: String, workTime: String, instagram: String, linkedin: String, youtube: String, website: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){

        let parameters = ["mastername":masterName,
                          "describe":describeWork,
                          "range":workTime,
                          "instagram":instagram,
                          "linkedin":linkedin,
                          "youtube":youtube,
                          "url":website]
        
        
        let pathUrl = "master/registration/one"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestRegistrationMasterStepTwo(parameters:Parameters, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let pathUrl = "master/registration/two"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, encoding: ArrayEncoding() , success: success, failure: failure)
    }
    
    func requestRegistrationMasterStepThree(parameters:Parameters?, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "master/registration/three"
        
        self.uploadMultipart(httppMethod: .post, pathURL: pathUrl,parameters: parameters, success: success, failure: failure)
    }
    
}
