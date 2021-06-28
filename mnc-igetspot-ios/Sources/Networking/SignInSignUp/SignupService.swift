////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class SignupService: IGSService {
    func requestRegisterUser(_ email: String, password: String, password2: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
    
        let parameters =  [
            "email": email,
            "password": EncryptHelper.aesEncrypt(string: password) ?? password,
            "confirm_password": EncryptHelper.aesEncrypt(string: password2) ?? password2
        ]
        let successApiResponse = { (apiResponse: MKAPIResponse) in
            success(apiResponse)
        }
        
        self.request(httppMethod: .post, pathUrl: "register",parameters: parameters, isAuthenticated: false, success: successApiResponse, failure: failure)
    }
}
