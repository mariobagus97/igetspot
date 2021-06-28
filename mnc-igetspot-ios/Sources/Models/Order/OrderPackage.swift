////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderPackage {

    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    static let KEY_ORDER_STATUS_STRING = "order_status_string"
    static let KEY_ORDER_STATUS = "order_status"
    static let KEY_TXID = "tXid"
    
    var packageId: String?
    var packageName: String?
    var packagePrice: String?
    var packageImageUrl: String?
    var orderStatus: String?
    var orderStatusString: String?
    var txId: String?
    var isSelected:Bool = false

    static func with(json: JSON) -> OrderPackage {
        
        let orderPackage = OrderPackage()
        orderPackage.isSelected = true
        
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
            orderPackage.packageImageUrl = json[KEY_PACKAGE_IMAGE_URL].arrayValue[0].stringValue
        }
        if (json[KEY_ORDER_STATUS_STRING].exists()) {
            orderPackage.orderStatusString = json[KEY_ORDER_STATUS_STRING].stringValue
        }
        if (json[KEY_ORDER_STATUS].exists()) {
            orderPackage.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if (json[KEY_TXID].exists()){
            orderPackage.txId = json[KEY_TXID].stringValue
        }
        
        return orderPackage
    }
    
    
    static func with(jsons: [JSON]) -> [OrderPackage] {
        var orderPackageArray = [OrderPackage]()
        
        for json in jsons {
            let orderPackage = OrderPackage.with(json: json)
            orderPackageArray.append(orderPackage)
        }
        return orderPackageArray
    }
}
