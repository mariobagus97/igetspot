////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class PaymentTransactionDetail {
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_DURATION = "package_duration"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_ORDER_DATE = "order_date"
    static let KEY_ORDER_ADDRESS = "order_address"
    static let KEY_SERVICE_DATE = "service_date"
    
    var packageName: String?
    var packageDuration: String?
    var packagePrice: String?
    var orderDate: String?
    var orderAddress: String?
    var serviceDate: String?
    
    static func with(json: JSON) -> PaymentTransactionDetail {
        
        let transactionDetail = PaymentTransactionDetail()
        
        if (json[KEY_PACKAGE_NAME].exists()) {
            transactionDetail.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if (json[KEY_PACKAGE_DURATION].exists()) {
            transactionDetail.packageDuration = json[KEY_PACKAGE_DURATION].stringValue
        }
        if (json[KEY_PACKAGE_PRICE].exists()) {
            transactionDetail.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_ORDER_DATE].exists()) {
            transactionDetail.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        if (json[KEY_ORDER_ADDRESS].exists()) {
            transactionDetail.orderAddress = json[KEY_ORDER_ADDRESS].stringValue
        }
        if (json[KEY_SERVICE_DATE].exists()) {
            transactionDetail.serviceDate = json[KEY_SERVICE_DATE].stringValue
        }
        
        return transactionDetail
    }
    
    static func with(jsons: [JSON]) -> [PaymentTransactionDetail] {
        var paymentTransactionDetailArray = [PaymentTransactionDetail]()
        
        for json in jsons {
            let bank = PaymentTransactionDetail.with(json: json)
            paymentTransactionDetailArray.append(bank)
        }
        
        return paymentTransactionDetailArray
    }
}
