////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotBalance {
    static let KEY_USER_ID = "user_id"
    static let KEY_BANK_NAME = "bank_name"
    static let KEY_ACCOUNT_NO = "account_no"
    static let KEY_USER_ADDRESS = "user_address"
    static let KEY_ACCOUNT_HOLDER = "account_holder"
    static let KEY_BALANCE = "balance"
    
    var userId: String?
    var bankName: String?
    var bankAccountNumber: String?
    var bankAccountHolder: String?
    var balance: String?
    
    static func with(json: JSON) -> MySpotBalance {
        
        let balance = MySpotBalance()
        
        if (json[KEY_USER_ID].exists()) {
            balance.userId = json[KEY_USER_ID].stringValue
        }
        if (json[KEY_BANK_NAME].exists()) {
            balance.bankName = json[KEY_BANK_NAME].stringValue
        }
        if (json[KEY_ACCOUNT_NO].exists()) {
            balance.bankAccountNumber = json[KEY_ACCOUNT_NO].stringValue
        }
        if (json[KEY_ACCOUNT_HOLDER].exists()) {
            balance.bankAccountHolder = json[KEY_ACCOUNT_HOLDER].stringValue
        }
        if (json[KEY_BALANCE].exists()) {
            balance.balance = json[KEY_BALANCE].stringValue
        }
        return balance
    }
}
