//
//  UserBankDetai.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 24/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//


import Foundation
import SwiftyJSON

class UserBankDetail {
    
    static let KEY_BANK_ID = "bank_id"
    static let KEY_ID = "id"
    static let KEY_USER_ID = "user_id"
    static let KEY_BANK_NAME = "bank_name"
    static let KEY_ACCOUNT_HOLDER = "account_holder"
    static let KEY_ACCOUNT_NO = "account_no"
    
    var bankId: String?
    var id: String?
    var userId: String?
    var bankName: String?
    var accountHolder: String?
    var accountNo: String?
    
    static func with(json: JSON) -> UserBankDetail {
        let data = UserBankDetail()
        
        if json[KEY_BANK_ID].exists(){
            data.bankId = json[KEY_BANK_ID].stringValue
        }
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_USER_ID].exists(){
            data.userId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_BANK_NAME].exists(){
            data.bankName = json[KEY_BANK_NAME].stringValue
        }
        if json[KEY_ACCOUNT_HOLDER].exists(){
            data.accountHolder = json[KEY_ACCOUNT_HOLDER].stringValue
        }
        if json[KEY_ACCOUNT_NO].exists(){
            data.accountNo = json[KEY_ACCOUNT_NO].stringValue
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [UserBankDetail] {
        var bankList = [UserBankDetail]()
        
        for json in jsons {
            let bank = UserBankDetail.with(json: json)
            bankList.append(bank)
        }
        
        return bankList
    }
}
