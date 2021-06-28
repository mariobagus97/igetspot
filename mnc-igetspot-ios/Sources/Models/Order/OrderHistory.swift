////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderHistory {
    
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_OF = "master_of"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    
    var masterId: String?
    var masterName: String?
    var masterOf: String?
    var masterImageUrl: String?
    
    static func with(json: JSON) -> OrderHistory {
        
        let orderHistory = OrderHistory()
        
        if (json[KEY_MASTER_ID].exists()) {
            orderHistory.masterId = json[KEY_MASTER_ID].stringValue
        }
        if (json[KEY_MASTER_NAME].exists()) {
            orderHistory.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if (json[KEY_MASTER_OF].exists()) {
            orderHistory.masterOf = json[KEY_MASTER_OF].stringValue
        }
        if (json[KEY_MASTER_IMAGE_URL].exists()) {
            orderHistory.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        
        return orderHistory
    }
    
    
    static func with(jsons: [JSON]) -> [OrderHistory] {
        var orderHistoryArray = [OrderHistory]()
        
        for json in jsons {
            let orderHistory = OrderHistory.with(json: json)
            orderHistoryArray.append(orderHistory)
        }
        
        return orderHistoryArray
    }
}
