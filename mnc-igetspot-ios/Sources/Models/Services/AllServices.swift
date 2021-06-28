//
//  AllServices.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/7/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class AllServices {
    
    static let KEY_CATEGORY_ID = "category_id"
    static let KEY_CATEGORY_MENU = "category_name"
    static let KEY_ICON_URL = "icon_url"
    static let KEY_SUBCATEGORIES = "subcategories"
    
    var categoryId : Int?
    var categoryMenu : String?
    var iconUrl : String?
    var subcategories : [SubCategories]?
    
    static func with(json: JSON) -> AllServices {
        let allServices = AllServices()
        
        if json[KEY_CATEGORY_ID].exists(){
            allServices.categoryId = json[KEY_CATEGORY_ID].intValue
        }
        if json[KEY_CATEGORY_MENU].exists(){
            allServices.categoryMenu = json[KEY_CATEGORY_MENU].stringValue
        }
        if json[KEY_ICON_URL].exists(){
            allServices.iconUrl = json[KEY_ICON_URL].stringValue
        }
        if json[KEY_SUBCATEGORIES].exists(){
            allServices.subcategories = SubCategories.with(jsons: json[KEY_SUBCATEGORIES].arrayValue)
        }
        
        return allServices
    }
    
    
    static func with(jsons: [JSON]) -> [AllServices] {
        var allServices = [AllServices]()
        
        for json in jsons {
            let allService = AllServices.with(json: json)
            allServices.append(allService)
        }
        
        return allServices
    }
}
