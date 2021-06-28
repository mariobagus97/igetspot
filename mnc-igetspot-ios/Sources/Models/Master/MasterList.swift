////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MasterList {
    static let KEY_ID = "id"
    static let KEY_MASTER_ID = "master_id"
    static let KEY_IMAGE = "image"
    static let KEY_DESCRIPTION = "description"
    static let KEY_NAME = "master_name"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_RATING = "rating"
    
    var id : String?
    var masterId : String?
    var imageUrl : String?
    var description : String?
    var name : String?
    var packageName : String?
    var rating : Float?
    
    static func with(json: JSON) -> MasterList {
        let data = MasterList()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_MASTER_ID].exists(){
            data.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_IMAGE].exists(){
            data.imageUrl = json[KEY_IMAGE].stringValue
        }
        if json[KEY_DESCRIPTION].exists(){
            data.description = json[KEY_DESCRIPTION].stringValue
        }
        if json[KEY_NAME].exists(){
            data.name = json[KEY_NAME].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_RATING].exists(){
            data.rating = json[KEY_RATING].floatValue
        }
        
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [MasterList] {
        var masterList = [MasterList]()
        
        for json in jsons {
            let master = MasterList.with(json: json)
            masterList.append(master)
        }
        
        return masterList
    }
}
