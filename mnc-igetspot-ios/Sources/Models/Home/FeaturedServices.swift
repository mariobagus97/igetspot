//
//  FeaturedServices.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class FeaturedServices {
    
    static let KEY_WHATSON = "whatson"
    static let KEY_CATEGORIES = "categories"
    
    var whatson : [Whatson]?
    var categories : [HomeCategory]?
    
    static func with(json: JSON) -> FeaturedServices {
        
        let data = FeaturedServices()
        
        data.whatson = Whatson.with(jsons: json[KEY_WHATSON].arrayValue)
        data.categories = HomeCategory.with(jsons: json[KEY_CATEGORIES].arrayValue)
        
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [FeaturedServices] {
        var list = [FeaturedServices]()
        
        for json in jsons {
            let data = FeaturedServices.with(json: json)
            list.append(data)
        }
        
        return list
    }
    
}
