////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class ForgotPasswordService: IGSService {
    
    func requestForgotPassword(email:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        let params = ["email":email]
        
        self.request(httppMethod: .post, pathUrl: "password/reset/request", parameters:params,  isAuthenticated: false, success: success, failure: failure)
    }
    
    
}
