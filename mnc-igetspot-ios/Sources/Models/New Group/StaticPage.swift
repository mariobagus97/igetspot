//
//  StaticPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class StaticPage {
    static let KEY_ID = "id"
    static let KEY_TITLE = "title"
    static let KEY_DESCRIPTION = "description"
    static let KEY_CREATED_AT = "created_at"
    static let KEY_UPDATED_AT = "updated_at"
    
    var id: String?
    var title: String?
    var description: String?
    var createdAt: String?
    var updatedAt:String?
    
    static func with(jsons: [JSON]) -> [StaticPage] {
        var staticList = [StaticPage]()
        
        for json in jsons {
            let item = StaticPage.with(json: json)
            staticList.append(item)
        }
        return staticList
    }
    
    static func with(json: JSON) -> StaticPage {
        let item = StaticPage()
        
        if json[KEY_ID].exists(){
            item.id = json[KEY_ID].stringValue
        }
        if json[KEY_TITLE].exists(){
            item.title = json[KEY_TITLE].stringValue
        }
        if json[KEY_DESCRIPTION].exists(){
            item.description = json[KEY_DESCRIPTION].stringValue
        }
        if json[KEY_CREATED_AT].exists(){
            item.createdAt = json[KEY_CREATED_AT].stringValue
        }
        if json[KEY_UPDATED_AT].exists(){
            item.updatedAt = json[KEY_UPDATED_AT].stringValue
        }
        
        return item
    }
}
