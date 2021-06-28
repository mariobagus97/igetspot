////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class TokenService: IGSService {
    
    func requestToken(_ email: String, password: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        var parameters =  [
            "password": EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        if email.isValidEmail() {
            parameters["email"] = email
        } else {
            parameters["username"] = email
        }
        
        let successApiResponse = { (apiResponse: MKAPIResponse) in
            success(apiResponse)
        }
        print("login param \(parameters)")
        self.request(httppMethod: .post, pathUrl: "login",parameters: parameters, isAuthenticated: false, success: successApiResponse, failure: failure)
    }
    
    func requestTokenSocialMedia(_ token: String, userId: String, email:String, typeLogin: SocialMediaLoginType, isLogin:Bool, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        /*var params: [String:Any] = ["userId":userId,
                                    "email":email,
                                    "type":typeLogin.rawValue]
        if typeLogin == .facebook {
            params["token"] = token
        } else {
            params["idToken"] = token
        }*/
        let params: [String: Any] = ["userId": userId,
                                     "email": email]
        
        let successApiResponse = { (apiResponse: MKAPIResponse) in
            success(apiResponse)
        }
        
        var pathUrl = ""
        switch typeLogin {
        case .google:
            pathUrl = "google/login"
        case .facebook:
            pathUrl = "facebook/login"
        case .apple:
            pathUrl = "apple/login"
        }
        
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: params, isAuthenticated: false, success: successApiResponse, failure: failure)
    }
    
}
