//
//  Whatson.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class Whatson {
    
    static let KEY_ID = "id"
    static let KEY_TITLE = "title"
    static let KEY_AUTHOR = "author"
    static let KEY_IMAGE_URL = "image_url"
    static let KEY_DATE = "date"
    static let KEY_DESC = "description"
    static let KEY_DETAIL = "detail"

    
    var id : String?
    var title : String?
    var author : String?
    var imageUrl : String?
    var date : String?
    var desc : String?
    var detail : String?

    
    static func with(json: JSON) -> Whatson {
            
        let data = Whatson()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_TITLE].exists(){
            data.title = json[KEY_TITLE].stringValue
        }
        if json[KEY_AUTHOR].exists(){
            data.author = json[KEY_AUTHOR].stringValue
        }
        if json[KEY_IMAGE_URL].exists(){
            data.imageUrl = json[KEY_IMAGE_URL].stringValue
        }
        if json[KEY_DATE].exists(){
            data.date = json[KEY_DATE].stringValue
        }
        if json[KEY_DESC].exists(){
            data.desc = json[KEY_DESC].stringValue
        }
        if json[KEY_DETAIL].exists(){
            data.detail = json[KEY_DETAIL].stringValue
        }
        
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [Whatson] {
        var list = [Whatson]()
        
        for json in jsons {
            let data = Whatson.with(json: json)
            list.append(data)
        }
        
        return list
    }
    
}
