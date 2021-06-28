//
//  TransactionVirtualAccount.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//


import Foundation
import SwiftyJSON

class TransactionVirtualAccount{
    
    static let KEY_VA_EXPIRED_DATE = "VA_expired_date"
    static let KEY_BANK_NAME = "bank_name"
    static let KEY_ORDER_STATUS = "order_status" //
    static let KEY_ORDER_ID = "order_id"
    static let KEY_USER_ID = "user_id"
    static let KEY_USER_NAME = "user_name"
    static let KEY_PAYMENT_AMOUNT = "payment_amount"
    static let KEY_PAYMENT_METHOD_NAME = "payment_method_name"
    static let KEY_TRANSACTION_DETAIL = "transaction_detail"
    static let KEY_USER_EMAIL = "user_email"
    static let KEY_ORDER_STATUS_STRING = "order_status_string" //
    static let KEY_TRANSACTION_DATE = "transaction_date"
    static let KEY_PARSE_TRANSACTION_DATE_STRING = "parse_transaction_date_string"
    static let KEY_INVOICE_ID = "invoice_id"
    static let KEY_VA_EXPIRED_TIME = "VA_expired_time"
    static let KEY_USER_PHONE = "user_phone"
    static let KEY_TRANSACTION_TIME = "transaction_time"
    static let KEY_VA_NO = "VA_no"
    static let KEY_PARSE_VA_EXPIRED_DATE_STRING = "parse_VA_expired_date_string"
    static let KEY_TX_ID = "tXid"
    
    static let KEY_MERCHANT_TOKEN = "merchant_token"
    static let KEY_PAYMENT_STATUS = "payment_status"
    
    var transactionTime: String?
    var orderStatus: String?
    var orderStatusString: String?
    var userId: String?
    var vaNo: String?
    var userPhone: String?
    var userEmail: String?
    var userName: String?
    var txId: String?
    var vaExpiredDateString: String?
    var bankName: String?
    var paymentMethodName: String?
    var transactionDateString: String?
    var vaExpiredTime: String?
    var orderId: String?
    var invoiceId: String?
    var paymentAmount: String?
    var vaExpiredDate: String?
    var transactionDate: String?
    var merchantToken: String?
    var paymentStatus: String?
    var transactionDetailArray: [TransactionDetailVA]?
    
    static func with(json: JSON) -> TransactionVirtualAccount {
        let data = TransactionVirtualAccount()
        
        if json[KEY_TRANSACTION_TIME].exists(){
            data.transactionTime = json[KEY_TRANSACTION_TIME].stringValue
        }
        if json[KEY_USER_ID].exists(){
            data.userId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_VA_NO].exists(){
            data.vaNo = json[KEY_VA_NO].stringValue
        }
        if json[KEY_ORDER_STATUS].exists(){
            data.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if json[KEY_ORDER_STATUS_STRING].exists(){
            data.orderStatusString = json[KEY_ORDER_STATUS_STRING].stringValue
        }
        if json[KEY_USER_PHONE].exists(){
            data.userPhone = json[KEY_USER_PHONE].stringValue
        }
        if json[KEY_USER_EMAIL].exists(){
            data.userEmail = json[KEY_USER_EMAIL].stringValue
        }
        if json[KEY_USER_NAME].exists(){
            data.userName = json[KEY_USER_NAME].stringValue
        }
        if json[KEY_TX_ID].exists(){
            data.txId = json[KEY_TX_ID].stringValue
        }
        if json[KEY_PARSE_VA_EXPIRED_DATE_STRING].exists(){
            data.vaExpiredDateString = json[KEY_PARSE_VA_EXPIRED_DATE_STRING].stringValue
        }
        if json[KEY_BANK_NAME].exists(){
            data.bankName = json[KEY_BANK_NAME].stringValue
        }
        if json[KEY_PAYMENT_METHOD_NAME].exists(){
            data.paymentMethodName = json[KEY_PAYMENT_METHOD_NAME].stringValue
        }
        if json[KEY_PARSE_TRANSACTION_DATE_STRING].exists(){
            data.paymentMethodName = json[KEY_PAYMENT_METHOD_NAME].stringValue
        }
        if json[KEY_VA_EXPIRED_TIME].exists(){
            data.paymentMethodName = json[KEY_PAYMENT_METHOD_NAME].stringValue
        }
        if json[KEY_ORDER_ID].exists(){
            data.orderId = json[KEY_ORDER_ID].stringValue
        }
        if json[KEY_INVOICE_ID].exists(){
            data.invoiceId = json[KEY_INVOICE_ID].stringValue
        }
        if json[KEY_PAYMENT_AMOUNT].exists(){
            data.paymentAmount = json[KEY_PAYMENT_AMOUNT].stringValue
        }
        if json[KEY_VA_EXPIRED_DATE].exists(){
            data.vaExpiredDate = json[KEY_VA_EXPIRED_DATE].stringValue
        }
        if json[KEY_TRANSACTION_DATE].exists(){
            data.transactionDate = json[KEY_TRANSACTION_DATE].stringValue
        }
        if json[KEY_MERCHANT_TOKEN].exists(){
            data.merchantToken = json[KEY_MERCHANT_TOKEN].stringValue
        }
        if json[KEY_PAYMENT_STATUS].exists(){
            data.paymentStatus = json[KEY_PAYMENT_STATUS].stringValue
        }
        if json[KEY_TRANSACTION_DETAIL].exists(){
            data.transactionDetailArray = TransactionDetailVA.with(jsons: json[KEY_TRANSACTION_DETAIL].arrayValue)
        }
        
        return data
    }
    
}
