//
//  ResetPasswordService.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 23/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

class ResetPasswordService: IGSService {
    func resetPassword(password: String, confirmPassword: String, token: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let params = ["app_token":token,
                      "new_password":EncryptHelper.aesEncrypt(string: password) ?? password,
                      "confirm_password":EncryptHelper.aesEncrypt(string: password) ?? confirmPassword
                      ]
        
        self.request(httppMethod: .post, baseUrl: IGSEnv.IGetSpotDomainUrl, pathUrl: "reset-password?app_token=\(token)&new_password=\(password)&confirm_password=\(confirmPassword)", parameters:params, success: success, failure: failure)
    }
}
