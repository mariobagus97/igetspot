//
//  PackageList.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class PackageList {
    
    static let KEY_ID = "category_id"
    static let KEY_TITLE = "title"
    static let KEY_PACKAGE_DETAIL_LIST = "package_detail_list"
    
    var title : String?
    var id : String?
    var packageDetailList : [PackageDetailList]?
 
    static func with(json: JSON) -> PackageList {
        
        let packageList = PackageList()
        
        packageList.title = json[KEY_TITLE].stringValue
        packageList.id = json[KEY_ID].stringValue

        packageList.packageDetailList = PackageDetailList.with(jsons: json[KEY_PACKAGE_DETAIL_LIST].arrayValue)
        
        return packageList
    }
    
    
    static func with(jsons: [JSON]) -> [PackageList] {
        var packageLists = [PackageList]()
        
        for json in jsons {
            let packageList = PackageList.with(json: json)
            packageLists.append(packageList)
        }
        
        return packageLists
    }
}
