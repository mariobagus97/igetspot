//
//  Bank.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON


class BankPayment {
    
    static let KEY_ID = "id"
    static let KEY_REFER_CODE = "ReferCode"
    static let KEY_REFER_NAME = "ReferName"
    static let KEY_REFER_ABBREVIATION = "ReferAbbreviation"
    static let KEY_REFER_IMAGE = "ReferImage"
    static let KEY_REFER_USED_BY = "ReferUsedBy"
    static let KEY_STATUS = "Status"
    
    var id: String?
    var referCode: String?
    var referName: String?
    var referAbbreviation: String?
    var referImage: String?
    var referUsedBy: String?
    var status: String?
    
    static func with(json: JSON) -> BankPayment {
        let data = BankPayment()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_REFER_CODE].exists(){
            data.referCode = json[KEY_REFER_CODE].stringValue
        }
        if json[KEY_REFER_NAME].exists(){
            data.referName = json[KEY_REFER_NAME].stringValue
        }
        if json[KEY_REFER_ABBREVIATION].exists(){
            data.referAbbreviation = json[KEY_REFER_ABBREVIATION].stringValue
        }
        if json[KEY_REFER_IMAGE].exists(){
            data.referImage = json[KEY_REFER_IMAGE].stringValue
        }
        if json[KEY_REFER_USED_BY].exists(){
            data.referUsedBy = json[KEY_REFER_USED_BY].stringValue
        }
        if json[KEY_STATUS].exists(){
            data.status = json[KEY_STATUS].stringValue
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [BankPayment] {
        var bankList = [BankPayment]()
        
        for json in jsons {
            let bank = BankPayment.with(json: json)
            bankList.append(bank)
        }
        
        return bankList
    }
}
