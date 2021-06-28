//
//  MySpotWhatToOffer.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/27/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

class MySpotWhatToOffer{
    
    static let KEY_CATEGORY_ID = "categoryID"
    static let KEY_SUBCATEGORY_ID = "subcategoryID"
    static let KEY_SERVICE_PACKAGE_NAME = "name"
    static let KEY_SERVICE_PACKAGE_DESCRIPTION = "description"
    static let KEY_PACKAGE_IMAGE = "image"
    static let KEY_PACKAGE_PRICE = "price"
    static let KEY_PACKAGE_DURATION = "duration"
    
    var categoryId : Int?
    var subcategoryId : Int?
    var servicePackageName : String?
    var packageDescription : String?
    var packageImage : [PackageImage]?
    var packagePrice : String?
    var packageDuration : String?
    
}
