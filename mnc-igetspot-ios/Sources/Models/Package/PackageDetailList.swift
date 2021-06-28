//
//  PackageDetailList.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class PackageDetailList {
    
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_IMAGE_URL = "package_images"
    static let KEY_PRICE = "package_price"
    
    static let KEY_PACKAGE_RATING = "package_rating"
    static let KEY_PACKAGE_REVIEW = "package_review"

    var packageId : String?
    var packageName : String?
    var imageUrls: [String]?
    var price : String?
    var packageRating : Int?
    var packageReview : Int?
    
    static func with(json: JSON) -> PackageDetailList {
        
        let packageDetailList = PackageDetailList()
        
        packageDetailList.packageId = json[KEY_PACKAGE_ID].stringValue
        packageDetailList.packageName = json[KEY_PACKAGE_NAME].stringValue
        packageDetailList.imageUrls = json[KEY_IMAGE_URL].arrayValue.map{$0.stringValue}
        packageDetailList.price = json[KEY_PRICE].stringValue
        packageDetailList.packageRating = json[KEY_PACKAGE_RATING].intValue
        packageDetailList.packageReview = json[KEY_PACKAGE_REVIEW].intValue

        return packageDetailList
    }
    
    
    static func with(jsons: [JSON]) -> [PackageDetailList] {
        var packageDetailLists = [PackageDetailList]()
        
        for json in jsons {
            let packageDetailList = PackageDetailList.with(json: json)
            packageDetailLists.append(packageDetailList)
        }
        
        return packageDetailLists
    }
}
