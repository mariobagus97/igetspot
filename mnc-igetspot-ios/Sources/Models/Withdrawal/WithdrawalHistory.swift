////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class WithdrawalHistory {
    
    /*
     "transaction_name": "Payment Order",
     "invoice_id": "INV/01/IGS/18/04/2019",
     "transaction_date": "2019-04-29 10:08:38",
     "transaction_activity": "IN",
     "transaction_amount": "15000",
     "last_balance": "0"
    */
    static let KEY_TRANSACTION_NAME = "transaction_name"
    static let KEY_INVOICE_ID = "transaction_id"
    static let KEY_TRANSACTION_DATE = "transaction_date"
    static let KEY_TRANSACTION_ACTIVITY = "transaction_activity"
    static let KEY_TRANSACTION_AMOUNT = "transaction_amount"
    static let KEY_LAST_BALANCE = "last_balance"
    
    var transactionName: String?
    var inoviceId: String?
    var transactionDate: String?
    var transactionActivity: String?
    var transactionAmount: String?
    var lastBalance: String?
    
    static func with(json: JSON) -> WithdrawalHistory {
        
        let withdrawalHistory = WithdrawalHistory()
        
        if (json[KEY_TRANSACTION_NAME].exists()) {
            withdrawalHistory.transactionName = json[KEY_TRANSACTION_NAME].stringValue
        }
        if (json[KEY_INVOICE_ID].exists()) {
            withdrawalHistory.inoviceId = json[KEY_INVOICE_ID].stringValue
        }
        if (json[KEY_TRANSACTION_DATE].exists()) {
            withdrawalHistory.transactionDate = json[KEY_TRANSACTION_DATE].stringValue
        }
        if (json[KEY_TRANSACTION_ACTIVITY].exists()) {
            withdrawalHistory.transactionActivity = json[KEY_TRANSACTION_ACTIVITY].stringValue
        }
        if (json[KEY_TRANSACTION_AMOUNT].exists()) {
            withdrawalHistory.transactionAmount = json[KEY_TRANSACTION_AMOUNT].stringValue
        }
        if (json[KEY_LAST_BALANCE].exists()) {
            withdrawalHistory.lastBalance = json[KEY_LAST_BALANCE].stringValue
        }
        
        return withdrawalHistory
    }
    
    
    static func with(jsons: [JSON]) -> [WithdrawalHistory] {
        var withdrawalHistoryArray = [WithdrawalHistory]()
        
        for json in jsons {
            let withdrawalHistory = WithdrawalHistory.with(json: json)
            withdrawalHistoryArray.append(withdrawalHistory)
        }
        
        return withdrawalHistoryArray
    }
}
