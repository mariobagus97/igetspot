////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class WithdrawalService: IGSService {
    
    func requestWithdrawal(amount:String, password:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["amount":amount.trimmingCharacters(in: .whitespacesAndNewlines),
                          "password":EncryptHelper.aesEncrypt(string: password) ?? password]
        
        self.request(httppMethod: .post, pathUrl: "transactions/withdrawal", parameters:parameters, success: success, failure: failure)
    }
    
    func requestAllWithdrawalHistory(userId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "transactions/history"
        self.request(httppMethod: .get, pathUrl: pathUrl, success: success, failure: failure)
    }
}
