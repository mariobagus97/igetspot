////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderRequest {
    
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_OF = "master_of"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    static let KEY_MASTER_SERVICE_LIST = "master_services_list"
    
    var masterId: String?
    var masterName: String?
    var masterOf: String?
    var masterImageUrl: String?
    var orderPackageArray: [OrderPackage]?
    var subTotalPrice:Int = 0
    
    static func with(json: JSON) -> OrderRequest {
        
        let orderRequest = OrderRequest()
        
        if (json[KEY_MASTER_ID].exists()) {
            orderRequest.masterId = json[KEY_MASTER_ID].stringValue
        }
        if (json[KEY_MASTER_NAME].exists()) {
            orderRequest.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if (json[KEY_MASTER_OF].exists()) {
            orderRequest.masterOf = json[KEY_MASTER_OF].stringValue
        }
        if (json[KEY_MASTER_IMAGE_URL].exists()) {
            orderRequest.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        if (json[KEY_MASTER_SERVICE_LIST].exists()) {
            orderRequest.orderPackageArray = OrderPackage.with(jsons: json[KEY_MASTER_SERVICE_LIST].arrayValue)
        }
        
        return orderRequest
    }
    
    
    static func with(jsons: [JSON]) -> [OrderRequest] {
        var orderRequestArray = [OrderRequest]()
        
        for json in jsons {
            let orderRequest = OrderRequest.with(json: json)
            orderRequestArray.append(orderRequest)
        }
        
        return orderRequestArray
    }
}
