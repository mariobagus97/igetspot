//
//  TransactionDetailVA.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 15/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class TransactionDetailVA{
    
    static let KEY_PACKAGE_DURATION = "package_duration"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_ORDER_DATE = "order_date"
    static let KEY_SERVICE_DATE = "service_date"
    static let KEY_ORDER_ADDRESS = "order_address"
    static let KEY_PACKAGE_NAME = "package_name"
    
    var packageDuration: String?
    var packagePrice: String?
    var orderDate: String?
    var serviceDate: String?
    var orderAddress: String?
    var packageName: String?
    
    static func with(json: JSON) -> TransactionDetailVA {
        
        let transactionDetail = TransactionDetailVA()
        
        if (json[KEY_PACKAGE_DURATION].exists()) {
            transactionDetail.packageDuration = json[KEY_PACKAGE_DURATION].stringValue
        }
        if (json[KEY_PACKAGE_PRICE].exists()) {
            transactionDetail.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_ORDER_DATE].exists()) {
            transactionDetail.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        if (json[KEY_SERVICE_DATE].exists()) {
            transactionDetail.serviceDate = json[KEY_SERVICE_DATE].stringValue
        }
        if (json[KEY_ORDER_ADDRESS].exists()) {
            transactionDetail.orderAddress = json[KEY_ORDER_ADDRESS].stringValue
        }
        if (json[KEY_PACKAGE_NAME].exists()) {
            transactionDetail.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        
        return transactionDetail
    }
    
    static func with(jsons: [JSON]) -> [TransactionDetailVA]{
        var transactions = [TransactionDetailVA]()
        
        for json in jsons {
            let transaction = TransactionDetailVA.with(json: json)
            transactions.append(transaction)
        }
        
        return transactions
    }
}
