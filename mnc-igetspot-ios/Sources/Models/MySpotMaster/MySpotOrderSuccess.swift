////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotOrderSuccess {
    static let KEY_TRANSACTION_ID = "transaction_id"
    static let KEY_ORDER_ID = "order_id"
    static let KEY_USER_ID = "user_id"
    static let KEY_USER_FIRST_LAST_NAME = "user_first_last_name"
    static let KEY_USER_NAME = "user_name"
    static let KEY_USER_IMAGE_URL = "user_image_url"
    static let KEY_ORDERED_PACKAGE_LIST = "ordered_package_list"
    
    var transactionId: String?
    var orderId: String?
    var userId: String?
    var userFirstNameLastName: String?
    var userName: String?
    var userImageUrl: String?
    var orderedPackageList: [MySpotOrderPackage]?
    
    static func with(json: JSON) -> MySpotOrderSuccess {
        
        let order = MySpotOrderSuccess()
        
        if (json[KEY_TRANSACTION_ID].exists()) {
            order.transactionId = json[KEY_TRANSACTION_ID].stringValue
        }
        if (json[KEY_ORDER_ID].exists()) {
            order.orderId = json[KEY_ORDER_ID].stringValue
        }
        if (json[KEY_USER_FIRST_LAST_NAME].exists()) {
            order.userFirstNameLastName = json[KEY_USER_FIRST_LAST_NAME].stringValue
        }
        if (json[KEY_USER_ID].exists()) {
            order.userId = json[KEY_USER_ID].stringValue
        }
        if (json[KEY_USER_NAME].exists()) {
            order.userName = json[KEY_USER_NAME].stringValue
        }
        if (json[KEY_USER_IMAGE_URL].exists()) {
            order.userImageUrl = json[KEY_USER_IMAGE_URL].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE_LIST].exists()) {
            order.orderedPackageList = MySpotOrderPackage.with(jsons: json[KEY_ORDERED_PACKAGE_LIST].arrayValue)
        }
        
        return order
    }
    
    static func with(jsons: [JSON]) -> [MySpotOrderSuccess] {
        var orderArray = [MySpotOrderSuccess]()
        
        for json in jsons {
            let order = MySpotOrderSuccess.with(json: json)
            orderArray.append(order)
        }
        
        return orderArray
    }
}
