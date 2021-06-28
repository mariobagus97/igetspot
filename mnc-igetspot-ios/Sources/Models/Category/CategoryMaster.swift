////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryMaster {
    
    static let KEY_ID = "id"
    static let KEY_CATEGORY_NAME = "category_name"
    static let KEY_CATEGORY_IMAGE = "category_image"
    static let KEY_MASTER_LIST = "master_list"
    
    var id : String?
    var categoryName : String?
    var categoryImageUrl : String?
    var masterList : [MasterList]?
    
    static func with(json: JSON) -> CategoryMaster {
        let data = CategoryMaster()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_CATEGORY_NAME].exists(){
            data.categoryName = json[KEY_CATEGORY_NAME].stringValue
        }
        if json[KEY_CATEGORY_IMAGE].exists(){
            data.categoryImageUrl = json[KEY_CATEGORY_IMAGE].stringValue
        }
        if json[KEY_MASTER_LIST].exists(){
            data.masterList = MasterList.with(jsons: json[KEY_MASTER_LIST].arrayValue)
        }
        
        return data
    }
}
