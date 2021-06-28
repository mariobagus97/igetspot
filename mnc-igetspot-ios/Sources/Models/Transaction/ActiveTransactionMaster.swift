////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActiveTransactionMaster {
    
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
    var packageArray: [ActiveTransactionPackage]?
    var invoiceID: String?
    
    static func with(json: JSON) -> ActiveTransactionMaster {
        
        let transactionMaster = ActiveTransactionMaster()
        
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
            transactionMaster.packageArray = ActiveTransactionPackage.with(jsons: json[KEY_MASTER_SERVICE_LIST].arrayValue)
        }
        
        if(json[KEY_INVOICE_ID].exists()){
            transactionMaster.invoiceID = json[KEY_INVOICE_ID].stringValue
        }
        
        return transactionMaster
    }
    
    
    static func with(jsons: [JSON]) -> [ActiveTransactionMaster] {
        var masterArray = [ActiveTransactionMaster]()
        
        for json in jsons {
            let master = ActiveTransactionMaster.with(json: json)
            masterArray.append(master)
        }
        
        return masterArray
    }
    
}
