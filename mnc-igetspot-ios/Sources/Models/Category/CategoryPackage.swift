////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryPackage {
    static let KEY_ID = "category_id"
    static let KEY_CATEGORY_NAME = "category_name"
    static let KEY_CATEGORY_BACKGROUND = "category_background"
    static let KEY_CATEGORY_IMAGE = "category_image"
    static let KEY_PACKAGE_LIST = "package_list"
    
    var id : String?
    var categoryName : String?
    var categoryBackgroundImageUrl: String?
    var categoryImageUrl : String?
    var packageArray : [Package]?
    
    static func with(json: JSON) -> CategoryPackage {
        let data = CategoryPackage()
        
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_CATEGORY_NAME].exists(){
            data.categoryName = json[KEY_CATEGORY_NAME].stringValue
        }
        if json[KEY_CATEGORY_IMAGE].exists(){
            data.categoryImageUrl = json[KEY_CATEGORY_IMAGE].stringValue
        }
        if json[KEY_CATEGORY_BACKGROUND].exists(){
            data.categoryBackgroundImageUrl = json[KEY_CATEGORY_BACKGROUND].stringValue
        }
        if json[KEY_PACKAGE_LIST].exists(){
            data.packageArray = Package.with(jsons: json[KEY_PACKAGE_LIST].arrayValue)
        }
        
        return data
    }
}
