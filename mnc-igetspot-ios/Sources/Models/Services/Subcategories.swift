//
//  Subcategories.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/7/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class SubCategories {
    
    static let KEY_SUBCATEGORY_ID = "subcategory_id"
    static let KEY_SUBCATEGORY_NAME = "subcategory_name"
    
    var subcategoryId : Int?
    var subcategoryName : String?
    
    static func with(json: JSON) -> SubCategories {
        let subCategory = SubCategories()
        
        if json[KEY_SUBCATEGORY_ID].exists(){
            subCategory.subcategoryId = json[KEY_SUBCATEGORY_ID].intValue
        }
        if json[KEY_SUBCATEGORY_NAME].exists(){
            subCategory.subcategoryName = json[KEY_SUBCATEGORY_NAME].stringValue
        }
        
        return subCategory
    }
 
    
    static func with(jsons: [JSON]) -> [SubCategories] {
        var subCategories = [SubCategories]()
        
        for json in jsons {
            let subCategory = SubCategories.with(json: json)
            subCategories.append(subCategory)
        }
        
        return subCategories
    }
}
