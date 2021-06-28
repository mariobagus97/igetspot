//
//  ServiceCategory.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServiceCategory {
    
    static let KEY_ID = "category_id"
    static let KEY_TITLE = "title"
    static let KEY_ICON_URL = "icon_url"
    static let KEY_SERVICE_DETAIL = "service_detail"
    static let KEY_package_id = "package_id"
    static let KEY_category_name = "category_name"
    
    var id : String?
    var title : String?
    var iconUrl : String?
    var serviceDetail : [ServiceCategory]?
    var subCategoryName: String?
    
    static func with(json: JSON) -> ServiceCategory {
        
        let serviceCategory = ServiceCategory()
        
        if json[KEY_SERVICE_DETAIL].exists(){
            let serviceDetails:[JSON] = json[KEY_SERVICE_DETAIL].arrayValue
            
            if(serviceDetails[0]["subcategory_name"].exists()){
                let servDetail = try? JSONDecoder().decode([ServiceDetail].self, from: json[KEY_SERVICE_DETAIL].rawData())
                var se = [ServiceCategory]()
                for item in servDetail! {
                    let value = ServiceCategory()
                    value.id = String(item.packageID!)
                    
                    value.title = item.packageName
                    
                    se.append(value)
                }
                serviceCategory.serviceDetail = se
            }else {
                serviceCategory.serviceDetail = ServiceCategory.with(jsons: json[KEY_SERVICE_DETAIL].arrayValue)
            }
        }
        
        if(json[KEY_category_name].exists()){
                   serviceCategory.title = json[KEY_category_name].stringValue
           } else {
               serviceCategory.title = json[KEY_TITLE].stringValue
           }
               
               
        serviceCategory.iconUrl = json[KEY_ICON_URL].stringValue
        
        return serviceCategory
    }
    
    
    static func with(jsons: [JSON]) -> [ServiceCategory] {
        var serviceCategories = [ServiceCategory]()
        
        for json in jsons {
            let serviceCategory = ServiceCategory.with(json: json)
            serviceCategories.append(serviceCategory)
        }
        
        return serviceCategories
    }
}
