//
//  MasterPackage.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 18/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class MasterPackage{
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_CITY = "city"
    static let KEY_PACKAGES = "packages"

    var masterID : String?
    var masterName : String?
    var city : String?
    var packages : [PackageList]?
    
    static func with(json: JSON) -> MasterPackage {
        
        let mp = MasterPackage()
        
        mp.masterID = json[KEY_MASTER_ID].stringValue
        mp.masterName = json[KEY_MASTER_NAME].stringValue
        
        mp.city = json[KEY_CITY].stringValue
        mp.packages = PackageList.with(jsons: json[KEY_PACKAGES].arrayValue)
        return mp
    }
}
