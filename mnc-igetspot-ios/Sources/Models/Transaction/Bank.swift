//
//  Bank.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON


class Bank {
    
    static let KEY_ID = "id"
    static let KEY_BANK_NAME = "bank_name"
    static let KEY_BANK_DESC = "bank_desc"
    static let KEY_BANK_IMAGE = "bank_image"
    static let KEY_BANK_STATUS = "bank_status"
    static let KEY_BANK_CODE = "bank_code"
    
    var id: String?
    var bankName: String?
    var bankDesc: String?
    var bankImage: String?
    var bankStatus: String?
    var bankCode: String?
    
    static func with(json: JSON) -> Bank {
        let data = Bank()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_BANK_NAME].exists(){
            data.bankName = json[KEY_BANK_NAME].stringValue
        }
        if json[KEY_BANK_DESC].exists(){
            data.bankDesc = json[KEY_BANK_DESC].stringValue
        }
        if json[KEY_BANK_IMAGE].exists(){
            data.bankImage = json[KEY_BANK_IMAGE].stringValue
        }
        if json[KEY_BANK_STATUS].exists(){
            data.bankStatus = json[KEY_BANK_STATUS].stringValue
        }
        if json[KEY_BANK_CODE].exists(){
            data.bankCode = json[KEY_BANK_CODE].stringValue
        }
        
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [Bank] {
        var bankList = [Bank]()
        
        for json in jsons {
            let bank = Bank.with(json: json)
            bankList.append(bank)
        }
        
        return bankList
    }
}
