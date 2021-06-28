//
//  RegisVA.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 05/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegisVA{
    
    static let KEY_TXID = "tXid"
    static let KEY_ORDER_ID = "order_id"
    static let KEY_MERCHANT_TOKEN = "merchant_token"
    
    var txId: String?
    var orderId: String?
    var merchantToken: String?
    
    static func with(json: JSON) -> RegisVA {
        let data = RegisVA()
        
        if json[KEY_TXID].exists(){
            data.txId = json[KEY_TXID].stringValue
        }
        if json[KEY_ORDER_ID].exists(){
            data.orderId = json[KEY_ORDER_ID].stringValue
        }
        if json[KEY_MERCHANT_TOKEN].exists(){
            data.merchantToken = json[KEY_MERCHANT_TOKEN].stringValue
        }
        
        return data
    }

}
