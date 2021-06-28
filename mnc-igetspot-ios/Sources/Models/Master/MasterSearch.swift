//
//  MasterSearch.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 26/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class MasterSearch {
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_AVG_RATING = "master_avg_rating"
    static let KEY_MASTER_TOTAL_REVIEW = "master_total_review"
    static let KEY_MASTER_ADDRESS = "master_address"
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    
    var masterId : String?
    var masterName : String? = ""
    var masterAvgRating : Double?
    var masterTotalReview : Int?
    var masterAddress : String?
    var packageId : String?
    var packageName : String?
    var packagePrice : String?
    var packageImageUrl : String?
    
    static func with(json: JSON) -> MasterSearch {
        let data = MasterSearch()
        
        if json[KEY_MASTER_ID].exists(){
            data.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_MASTER_AVG_RATING].exists(){
            data.masterAvgRating = json[KEY_MASTER_AVG_RATING].doubleValue
        }
        if json[KEY_MASTER_TOTAL_REVIEW].exists(){
            data.masterTotalReview = json[KEY_MASTER_TOTAL_REVIEW].intValue
        }
        if json[KEY_MASTER_ADDRESS].exists(){
            data.masterAddress = json[KEY_MASTER_ADDRESS].stringValue
        }
        if json[KEY_PACKAGE_ID].exists(){
            data.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_PACKAGE_PRICE].exists(){
            data.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if json[KEY_PACKAGE_IMAGE_URL].exists(){
            data.packageImageUrl = json[KEY_PACKAGE_IMAGE_URL].arrayValue[0].stringValue
        }
        
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [MasterSearch] {
        var masterList = [MasterSearch]()
        
        for json in jsons {
            let master = MasterSearch.with(json: json)
            masterList.append(master)
        }
        
        return masterList
    }
}
