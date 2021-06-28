////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActiveTransaction {
    
    static let KEY_ORDER_ID = "order_id"
    static let KEY_TRANSACTION_ID = "transaction_id"
    static let KEY_MASTER_LIST = "master_list"
    
    var orderId: String?
    var transactionId: String?
    var masterArray: [ActiveTransactionMaster]?
    var isExpand = true
    
    static func with(json: JSON) -> ActiveTransaction {
        
        let activeTransaction = ActiveTransaction()
        activeTransaction.isExpand = true
        
        if (json[KEY_ORDER_ID].exists()) {
            activeTransaction.orderId = json[KEY_ORDER_ID].stringValue
        }
        if (json[KEY_TRANSACTION_ID].exists()) {
            activeTransaction.transactionId = json[KEY_TRANSACTION_ID].stringValue
        }
        if (json[KEY_MASTER_LIST].exists()) {
            activeTransaction.masterArray = ActiveTransactionMaster.with(jsons: json[KEY_MASTER_LIST].arrayValue)
        }
        
        return activeTransaction
    }
    
    static func with(jsons: [JSON]) -> [ActiveTransaction] {
        var activeTransactionArray = [ActiveTransaction]()
        
        for json in jsons {
            let transaction = ActiveTransaction.with(json: json)
            activeTransactionArray.append(transaction)
        }
        
        return activeTransactionArray
    }
}
