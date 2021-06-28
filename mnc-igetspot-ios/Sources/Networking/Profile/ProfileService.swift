////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class ProfileService: IGSService {
    
    func requestProfile(_ success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "user/detail"
        
        self.request(httppMethod: .get, pathUrl: pathUrl, success: success, failure: failure)
    }
    
    func requestGetAvatar(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "image/avatar/get"
        
        self.request(httppMethod: .post, pathUrl: pathUrl, success: success, failure: failure)
    }
    
    func requestUserBalance(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "user/balance", success: success, failure: failure)
    }
}
