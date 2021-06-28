////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class WaitingTransactionPackage {
    
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    static let KEY_ORDER_STATUS_STRING = "order_status_string"
    static let KEY_ORDER_STATUS = "order_status"
    
    var packageId: String?
    var packageName: String?
    var packagePrice: String?
    var packageImageUrl: String?
    var orderStatus: String?
    var orderStatusString: String?
    
    static func with(json: JSON) -> WaitingTransactionPackage {
        
        let transactionPackage = WaitingTransactionPackage()
        
        if (json[KEY_PACKAGE_ID].exists()) {
            transactionPackage.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if (json[KEY_PACKAGE_NAME].exists()) {
            transactionPackage.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if (json[KEY_PACKAGE_PRICE].exists()) {
            transactionPackage.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_PACKAGE_IMAGE_URL].exists()) {
            transactionPackage.packageImageUrl = json[KEY_PACKAGE_IMAGE_URL].stringValue
        }
        if (json[KEY_ORDER_STATUS_STRING].exists()) {
            transactionPackage.orderStatusString = json[KEY_ORDER_STATUS_STRING].stringValue
        }
        if (json[KEY_ORDER_STATUS].exists()) {
            transactionPackage.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        
        return transactionPackage
    }
    
    
    static func with(jsons: [JSON]) -> [WaitingTransactionPackage] {
        var transactionPackageArray = [WaitingTransactionPackage]()
        
        for json in jsons {
            let transactionPackage = WaitingTransactionPackage.with(json: json)
            transactionPackageArray.append(transactionPackage)
        }
        
        return transactionPackageArray
    }
    
}
