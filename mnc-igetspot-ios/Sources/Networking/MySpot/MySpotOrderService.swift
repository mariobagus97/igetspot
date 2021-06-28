////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit

class MySpotOrderService: IGSService {
    
    func requestOrderWaitingList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "spot/order/list/wait", success: success, failure: failure)
    }
    
    func requestOrderDetail(orderId:String, packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["orderID":orderId,
                          "packageID":packageId]
        
        self.request(httppMethod: .get, pathUrl: "spot/order", parameters:parameters, success: success, failure: failure)
    }
    
    func requestOrderConfirmation(orderId:String, packageId:String, isConfirmed:Bool, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters:[String:Any] = ["order_id":orderId,
                                       "package_id":packageId,
                                       "confirm":isConfirmed]
        
        self.request(httppMethod: .post, pathUrl: "spot/order/confirmation", parameters:parameters, success: success, failure: failure)
    }

    func requestOrderActiveList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "spot/order/list/active", success: success, failure: failure)
    }
    
    func requestOrderSuccessList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "spot/order/list/complete", success: success, failure: failure)
    }
    
    func requestCompleteOrder(orderId:String,invoiceId:String,packageId:String, image:UIImage, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["order_id":orderId,
                          "invoice_id":invoiceId,
                          "package_id":packageId,
                          "image":image.jpgToBase64String()]
        
        self.request(httppMethod: .post, pathUrl: "spot/order/complete", parameters: parameters, success: success, failure: failure)
    }
}
