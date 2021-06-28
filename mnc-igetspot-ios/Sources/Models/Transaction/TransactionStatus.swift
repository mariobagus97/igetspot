////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class TransactionStatus {
    
    static let KEY_STATUS = "status"
    static let KEY_TITLE = "title"
    static let KEY_DESCRIPTION = "description"
    
    var statusDone: Bool?
    var statusTitle: String?
    var statusDescription: String?
    
    static func with(json: JSON) -> TransactionStatus {
        
        let transactionStatus = TransactionStatus()
        
        if (json[KEY_STATUS].exists()) {
            transactionStatus.statusDone = json[KEY_STATUS].boolValue
        }
        if (json[KEY_TITLE].exists()) {
            transactionStatus.statusTitle = json[KEY_TITLE].stringValue
        }
        if (json[KEY_DESCRIPTION].exists()) {
            transactionStatus.statusDescription = json[KEY_DESCRIPTION].stringValue
        }
        
        return transactionStatus
    }
    
    
    static func with(jsons: [JSON]) -> [TransactionStatus] {
        var transactionStatusArray = [TransactionStatus]()
        
        for json in jsons {
            let transactionStatus = TransactionStatus.with(json: json)
            transactionStatusArray.append(transactionStatus)
        }
        
        return transactionStatusArray
    }
}
