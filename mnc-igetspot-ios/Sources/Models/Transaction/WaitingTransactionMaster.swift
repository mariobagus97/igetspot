////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class WaitingTransactionMaster {
    
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_OF = "master_of"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    static let KEY_MASTER_SERVICE_LIST = "master_services_list"
    static let KEY_INVOICE_ID = "invoice_id"
    
    var masterId: String?
    var masterName: String?
    var masterOf: String?
    var masterImageUrl: String?
    var packageArray: [OrderPackage]?
    var invoiceID : String?
    
    static func with(json: JSON) -> WaitingTransactionMaster {
        
        let transactionMaster = WaitingTransactionMaster()
        
        if (json[KEY_MASTER_ID].exists()) {
            transactionMaster.masterId = json[KEY_MASTER_ID].stringValue
        }
        if (json[KEY_MASTER_NAME].exists()) {
            transactionMaster.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if (json[KEY_MASTER_OF].exists()) {
            transactionMaster.masterOf = json[KEY_MASTER_OF].stringValue
        }
        if (json[KEY_MASTER_IMAGE_URL].exists()) {
            transactionMaster.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        if (json[KEY_MASTER_SERVICE_LIST].exists()) {
            transactionMaster.packageArray = OrderPackage.with(jsons: json[KEY_MASTER_SERVICE_LIST].arrayValue)
        }
        
        if (json[KEY_INVOICE_ID].exists()){
            transactionMaster.invoiceID = json[KEY_INVOICE_ID].stringValue
        }
        
        return transactionMaster
    }
    
    
    static func with(jsons: [JSON]) -> [WaitingTransactionMaster] {
        var masterArray = [WaitingTransactionMaster]()
        
        for json in jsons {
            let master = WaitingTransactionMaster.with(json: json)
            masterArray.append(master)
        }
        
        return masterArray
    }
    
}
