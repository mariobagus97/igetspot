//
//  TransactionPayment.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/27/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON


class TransactionPayment {
    
    static let KEY_ORDER_ID = "order_id"
    static let KEY_NAME = "name"
    static let KEY_EMAIL = "email"
    static let KEY_SUBTOTAL = "subtotal"
    static let KEY_TOTAL = "total"
    static let KEY_PAYMENT_STATUS = "payment_status"
    static let KEY_TRANSACTION_DETAIL = "transaction_detail"
    
    var orderId: String?
    var name: String?
    var email: String?
    var subtotal: String?
    var total: String?
    var paymentStatus: String?
    var transactionDetail: [TransactionDetail]?
    
    static func with(json: JSON) -> TransactionPayment {
        let data = TransactionPayment()
        
        if json[KEY_ORDER_ID].exists(){
            data.orderId = json[KEY_ORDER_ID].stringValue
        }
        if json[KEY_NAME].exists(){
            data.name = json[KEY_NAME].stringValue
        }
        if json[KEY_EMAIL].exists(){
            data.email = json[KEY_EMAIL].stringValue
        }
        if json[KEY_SUBTOTAL].exists(){
            data.subtotal = json[KEY_SUBTOTAL].stringValue
        }
        if json[KEY_TOTAL].exists(){
            data.total = json[KEY_TOTAL].stringValue
        }
        if json[KEY_PAYMENT_STATUS].exists(){
            data.paymentStatus = json[KEY_PAYMENT_STATUS].stringValue
        }
        if json[KEY_TRANSACTION_DETAIL].exists(){
            data.transactionDetail = TransactionDetail.with(jsons: json[KEY_TOTAL].arrayValue)
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [TransactionPayment] {
        var transactions = [TransactionPayment]()
        
        for json in jsons {
            let transaction = TransactionPayment.with(json: json)
            transactions.append(transaction)
        }
        
        return transactions
    }
}
