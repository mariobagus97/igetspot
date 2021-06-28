////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class WaitingTransaction {
    
    static let KEY_ORDER_ID = "order_id"
    static let KEY_MASTER_LIST = "master_list"
    static let KEY_TRANSACTION_ID = "transaction_id"
    static let KEY_PAYMENT_STATUS = "payment_status"
    
    var orderId: String?
    var transactionId: String?
    var masterArray: [WaitingTransactionMaster]?
    var paymentStatus: String?
    var isExpand = true

    static func with(json: JSON) -> WaitingTransaction {
        
        let waitingTransaction = WaitingTransaction()
        waitingTransaction.isExpand = true
        
        if (json[KEY_ORDER_ID].exists()) {
            waitingTransaction.orderId = json[KEY_ORDER_ID].stringValue
        }
        if (json[KEY_TRANSACTION_ID].exists()) {
            waitingTransaction.transactionId = json[KEY_TRANSACTION_ID].stringValue
        }
        if (json[KEY_PAYMENT_STATUS].exists()) {
            waitingTransaction.paymentStatus = json[KEY_PAYMENT_STATUS].stringValue
        }
        if (json[KEY_MASTER_LIST].exists()) {
            waitingTransaction.masterArray = WaitingTransactionMaster.with(jsons: json[KEY_MASTER_LIST].arrayValue)
        }
        
        return waitingTransaction
    }
    
    static func with(jsons: [JSON]) -> [WaitingTransaction] {
        var waitingTransactionArray = [WaitingTransaction]()
        
        for json in jsons {
            let transaction = WaitingTransaction.with(json: json)
            waitingTransactionArray.append(transaction)
        }
        
        return waitingTransactionArray
    }
}
