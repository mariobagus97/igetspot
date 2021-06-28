////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Alamofire

class OrderService: IGSService {
    
    func requestOrderDraft(packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["package_id":packageId]
        
        self.request(httppMethod: .post, pathUrl: "order/draft", parameters: parameters, success: success, failure: failure)
    }
    
    func requestOrderDraftAdd(parameters:[String:Any], success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        self.request(httppMethod: .post, pathUrl: "order/drafts", parameters: parameters, success: success, failure: failure)
    }
    
    func requestOrderDraftList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "order/drafts", success: success, failure: failure)
    }
    
    func requestDeleteOrderPackage(packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .delete, pathUrl: "order/drafts/\(packageId)", success: success, failure: failure)
    }
    
    func requestSubmitOrder(parameters:Parameters, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .post, pathUrl: "order",parameters: parameters, encoding: ArrayEncoding(), success: success, failure: failure)
    }
    
    func requestHistoryOrderList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "order/list/history", success: success, failure: failure)
    }
    
    func requestHistoryOrderDetail(masterId:String, orderID:String,packageID:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["masterID":masterId,"orderID":orderID,"packageID":packageID]

        
        let pathUrl = "order/history/detail"
        self.request(httppMethod: .get, pathUrl: pathUrl,parameters: parameters, success: success, failure: failure)
    }

}
