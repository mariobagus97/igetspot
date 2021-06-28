////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeCategory {
    var id : String?
    var categoryName : String?
    var imageUrl : String?
    var link : String?
    
    static let KEY_ID = "id"
    static let KEY_CATEGORY_MENU = "name"
    static let KEY_IMAGE = "image_url"
    static let KEY_LINK = "description"

    static func with(json: JSON) -> HomeCategory {
        let category  = HomeCategory()
        
        category.id = json[KEY_ID].stringValue
        category.categoryName = json[KEY_CATEGORY_MENU].stringValue
        category.imageUrl = json[KEY_IMAGE].stringValue
        category.link = json[KEY_LINK].stringValue
        
        return category
    }
    
    
    static func with(jsons: [JSON]) -> [HomeCategory] {
        var categories = [HomeCategory]()
        
        for json in jsons {
            let category = HomeCategory.with(json: json)
            categories.append(category)
        }
        
        let category = HomeCategory()
        category.id = String(categories.count + 1)
        category.categoryName = "More"
        category.imageUrl = ""
        category.link = ""
        
        categories.append(category)
        
        return categories
    }
}
