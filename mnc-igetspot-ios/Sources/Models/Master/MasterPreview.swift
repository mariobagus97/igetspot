////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MasterPreview {
    
    static let KEY_ID = "master_id"
    static let KEY_MASTERNAME = "mastername"
    static let KEY_IMAGE_URL = "image_url"
    static let KEY_IMAGE = "image"
    static let USER_ID = "user_id"
    static let KEY_MASTEROF = "masterOf"
    static let KEY_MASTERNAME_DASH = "master_name"

    var id : String?
    var imageUrl : String?
    var masterName : String?
    var masterOf : String?
    
    static func with(json: JSON) -> MasterPreview {
        let data = MasterPreview()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[USER_ID].exists(){
            data.id = json[USER_ID].stringValue
        }
        
        if json[KEY_MASTERNAME].exists(){
            data.masterName = json[KEY_MASTERNAME].stringValue
        }
        
        if json[KEY_MASTERNAME_DASH].exists(){
            data.masterName = json[KEY_MASTERNAME_DASH].stringValue
        }
        
        if json[KEY_IMAGE_URL].exists(){
            data.imageUrl = json[KEY_IMAGE_URL].stringValue
        }
        
        if json[KEY_IMAGE].exists(){
            data.imageUrl = json[KEY_IMAGE].stringValue
        }
    
        if json[KEY_MASTEROF].exists(){
            data.masterOf = json[KEY_MASTEROF].stringValue
        }
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [MasterPreview] {
        var masterPreviewArray = [MasterPreview]()
        
        for json in jsons {
            let masterPreview = MasterPreview.with(json: json)
            masterPreviewArray.append(masterPreview)
        }
        
        return masterPreviewArray
    }
}
