////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation


class TermsConditionService: IGSService {
    
    func requestTermsCondition(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "dashboard/getStatic", isAuthenticated: false, success: success, failure: failure)
    }
}
