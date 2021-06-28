////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TransactionFlag:Int {
    case waitingConfirmation = 1
    case active = 2
}

class TransactionDetail {
    
    static let KEY_ORDER_STATUS = "order_status"
    static let KEY_USERID = "userid"
    static let KEY_FULLNAME = "fullname"
    static let KEY_EMAIL = "email"
    static let KEY_PHONE = "phone"
    static let KEY_TRANSACTION_NO = "transaction_no"
    static let KEY_MASTERID = "masterid"
    static let KEY_MASTERNAME = "mastername"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_DURATION = "package_duration"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_ORDER_NOTE = "order_note"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    static let KEY_ORDER_DATE = "order_date"
    
    var orderStatus: String?
    var userId: String?
    var userFullName: String?
    var userEmail: String?
    var userPhoneNumber: String?
    var transactionNumber: String?
    var masterName: String?
    var masterId: String?
    var packageName: String?
    var packageDuration: String?
    var packagePrice: String?
    var orderNote: String?
    var masterImageUrl: String?
    var orderDate: String?
    
    static func with(json: JSON) -> TransactionDetail {
        
        let transactionDetail = TransactionDetail()
        
        if (json[KEY_ORDER_STATUS].exists()) {
            transactionDetail.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if (json[KEY_USERID].exists()) {
            transactionDetail.userId = json[KEY_USERID].stringValue
        }
        if (json[KEY_FULLNAME].exists()) {
            transactionDetail.userFullName = json[KEY_FULLNAME].stringValue
        }
        if (json[KEY_EMAIL].exists()) {
            transactionDetail.userEmail = json[KEY_EMAIL].stringValue
        }
        if (json[KEY_PHONE].exists()) {
            transactionDetail.userPhoneNumber = json[KEY_PHONE].stringValue
        }
        if (json[KEY_TRANSACTION_NO].exists()) {
            transactionDetail.transactionNumber = json[KEY_TRANSACTION_NO].stringValue
        }
        if (json[KEY_MASTERID].exists()) {
            transactionDetail.masterId = json[KEY_MASTERID].stringValue
        }
        if (json[KEY_MASTERNAME].exists()) {
            transactionDetail.masterName = json[KEY_MASTERNAME].stringValue
        }
        if (json[KEY_PACKAGE_NAME].exists()) {
            transactionDetail.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if (json[KEY_PACKAGE_DURATION].exists()) {
            transactionDetail.packageDuration = json[KEY_PACKAGE_DURATION].stringValue
        }
        if (json[KEY_PACKAGE_PRICE].exists()) {
            transactionDetail.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_ORDER_NOTE].exists()) {
            transactionDetail.orderNote = json[KEY_ORDER_NOTE].stringValue
        }
        if (json[KEY_MASTER_IMAGE_URL].exists()) {
            transactionDetail.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        if (json[KEY_ORDER_DATE].exists()) {
            transactionDetail.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        return transactionDetail
    }
    
    static func with(jsons: [JSON]) -> [TransactionDetail] {
        var transactions = [TransactionDetail]()
        
        for json in jsons {
            let transaction = TransactionDetail.with(json: json)
            transactions.append(transaction)
        }
        
        return transactions
    }
}
