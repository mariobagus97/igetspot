////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderHistoryPackage {
    
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_IMAGE_URL = "package_image"
    static let KEY_ORDER_STATUS_STRING = "order_status_string"
    static let KEY_ORDER_STATUS = "order_status"
    static let KEY_ORDER_TIME = "order_time"
    static let KEY_ORDER_DATE_STRING = "order_date_string"
    static let KEY_ORDER_ID = "order_id"
    static let KEY_ORDER_DATE = "order_date"
    
    var packageId: String?
    var packageName: String?
    var packagePrice: String?
    var packageImageUrl: String?
    var orderStatus: String?
    var orderStatusString: String?
    var orderTime: String?
    var orderDateString: String?
    var orderId: String?
    var orderDate: String?
    
    static func with(json: JSON) -> OrderHistoryPackage {
        
        let orderPackage = OrderHistoryPackage()
        
        if (json[KEY_PACKAGE_ID].exists()) {
            orderPackage.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if (json[KEY_PACKAGE_NAME].exists()) {
            orderPackage.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if (json[KEY_PACKAGE_PRICE].exists()) {
            orderPackage.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_PACKAGE_IMAGE_URL].exists()) {
            orderPackage.packageImageUrl = json[KEY_PACKAGE_IMAGE_URL].stringValue
        }
        if (json[KEY_ORDER_STATUS_STRING].exists()) {
            orderPackage.orderStatusString = json[KEY_ORDER_STATUS_STRING].stringValue
        }
        if (json[KEY_ORDER_STATUS].exists()) {
            orderPackage.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if (json[KEY_ORDER_TIME].exists()) {
            orderPackage.orderTime = json[KEY_ORDER_TIME].stringValue
        }
        if (json[KEY_ORDER_DATE_STRING].exists()) {
            orderPackage.orderDateString = json[KEY_ORDER_DATE_STRING].stringValue
        }
        if (json[KEY_ORDER_ID].exists()) {
            orderPackage.orderId = json[KEY_ORDER_ID].stringValue
        }
        if (json[KEY_ORDER_DATE].exists()) {
            orderPackage.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        return orderPackage
    }
    
    
    static func with(jsons: [JSON]) -> [OrderHistoryPackage] {
        var orderPackageArray = [OrderHistoryPackage]()
        
        for json in jsons {
            let orderPackage = OrderHistoryPackage.with(json: json)
            orderPackageArray.append(orderPackage)
        }
        
        return orderPackageArray
    }
}
