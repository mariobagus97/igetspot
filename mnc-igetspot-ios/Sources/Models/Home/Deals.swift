//
//  Deals.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Deals{
    
    var id : String = ""
    var title : String = ""
    var imageUrl : String = ""
    var link : String = ""
    var description : String = ""
    var deals : String = ""
    var rate : String = ""
    
    
    static let KEY_ID = "id"
    static let KEY_TITLE = "title"
    static let KEY_IMAGE_URL = "image_url"
    static let KEY_LINK = "link"
    static let KEY_DESCRIPTION = "description"
    static let KEY_DEALS = "deals"
    static let KEY_RATE = "rate"
    
    static func with(json: JSON) -> Deals {
        let deal  = Deals()
        
        deal.id = json[KEY_ID].stringValue
        deal.title = json[KEY_TITLE].stringValue
        deal.imageUrl = json[KEY_IMAGE_URL].stringValue
        deal.link = json[KEY_LINK].stringValue
        deal.description = json[KEY_DESCRIPTION].stringValue
        deal.deals = json[KEY_DEALS].stringValue
        deal.rate = json[KEY_RATE].stringValue
    
        return deal
    }
    
    
    static func with(jsons: [JSON]) -> [Deals] {
        var deals = [Deals]()
        
            for json in jsons {
                let deal = Deals.with(json: json)
                deals.append(deal)
            }
        
        return deals
    }
}
