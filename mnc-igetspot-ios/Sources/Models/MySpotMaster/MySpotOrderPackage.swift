////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotOrderPackage {
    
    static let KEY_ORDER_DATE = "order_date"
    static let KEY_ORDER_TIME = "order_time"
    static let KEY_ORDER_DATE_TIME_PARSING = "order_date_time_parse_string"
    static let KEY_ORDER_STATUS = "order_status"
    static let KEY_ORDER_STATUS_STRING = "order_status_string"
    static let KEY_ORDERED_PACKAGE_ID = "ordered_package_id"
    static let KEY_ORDERED_PACKAGE_NAME = "ordered_package_name"
    static let KEY_ORDERED_PACKAGE_PRICE = "ordered_package_price"
    static let KEY_ORDERED_PACKAGE_IMAGE_URL = "ordered_package_image_url"
    
    var orderDate: String?
    var orderTime: String?
    var orderDateTimeParseString: String?
    var orderStatus: String?
    var orderStatusString: String?
    var packageId: String?
    var packageName: String?
    var packagePrice: String?
    var packageImageUrl: String?
    
    static func with(json: JSON) -> MySpotOrderPackage {
        
        let package = MySpotOrderPackage()
        
        if (json[KEY_ORDER_DATE].exists()) {
            package.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        if (json[KEY_ORDER_TIME].exists()) {
            package.orderTime = json[KEY_ORDER_TIME].stringValue
        }
        if (json[KEY_ORDER_DATE_TIME_PARSING].exists()) {
            package.orderDateTimeParseString = json[KEY_ORDER_DATE_TIME_PARSING].stringValue
        }
        if (json[KEY_ORDER_STATUS].exists()) {
            package.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if (json[KEY_ORDER_STATUS_STRING].exists()) {
            package.orderStatusString = json[KEY_ORDER_STATUS_STRING].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE_ID].exists()) {
            package.packageId = json[KEY_ORDERED_PACKAGE_ID].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE_NAME].exists()) {
            package.packageName = json[KEY_ORDERED_PACKAGE_NAME].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE_PRICE].exists()) {
            package.packagePrice = json[KEY_ORDERED_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_ORDERED_PACKAGE_IMAGE_URL].exists()) {
            package.packageImageUrl = json[KEY_ORDERED_PACKAGE_IMAGE_URL].arrayValue[0].stringValue
        }
        
        return package
    }
    
    static func with(jsons: [JSON]) -> [MySpotOrderPackage] {
        var packageArray = [MySpotOrderPackage]()
        
        for json in jsons {
            let package = MySpotOrderPackage.with(json: json)
            packageArray.append(package)
        }
        
        return packageArray
    }
}
