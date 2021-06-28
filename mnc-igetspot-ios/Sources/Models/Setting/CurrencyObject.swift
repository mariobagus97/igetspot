//
//  CurrencyObject.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 15/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CurrencyObject: Object {
    
    @objc dynamic var currencyId: String = ""
    @objc dynamic var currencyCode: String = ""
    @objc dynamic var currencyName: String = ""
    @objc dynamic var isChosen: Bool = false

    
    convenience required init(currencyId: String, currencyCode: String, currencyName: String, isChosen: Bool? = false) {
        self.init()
        
        self.currencyId = currencyId
        self.currencyCode = currencyCode
        self.currencyName = currencyName
        self.isChosen = isChosen ?? false
    }
    
    override class func primaryKey() -> String? {
        return "currencyId"
    }

}
