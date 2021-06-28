////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderHistoryDetail {
    
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "mastername"
    static let KEY_ORDERED_PACKAGE = "ordered_package"
    
    var masterId: String?
    var masterName: String?
    var orderPackageArray: [OrderHistoryPackage]?
    
    static func with(json: JSON) -> OrderHistoryDetail {
        
        let orderHistoryDetail = OrderHistoryDetail()
        
        if (json[KEY_MASTER_ID].exists()) {
            orderHistoryDetail.masterId = json[KEY_MASTER_ID].stringValue
        }
        if (json[KEY_MASTER_NAME].exists()) {
            orderHistoryDetail.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE].exists()) {
            orderHistoryDetail.orderPackageArray = OrderHistoryPackage.with(jsons: json[KEY_ORDERED_PACKAGE].arrayValue)
        }
        
        return orderHistoryDetail
    }
}
