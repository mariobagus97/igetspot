////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

import SwiftyJSON

class MySpotPackages {
    
    static let KEY_CATEGORY_ID = "category_id"
    static let KEY_CATEGORY_TITLE = "category_name"
    static let KEY_PACKAGE_LIST = "package_list"
    
    var categoryTitle : String?
    var categoryId : String?
    var packageArray : [MySpotPackage]?
    
    static func with(json: JSON) -> MySpotPackages {
        
        let packageList = MySpotPackages()
        
        packageList.categoryTitle = json[KEY_CATEGORY_TITLE].stringValue
        packageList.categoryId = json[KEY_CATEGORY_ID].stringValue
        
        packageList.packageArray = MySpotPackage.with(jsons: json[KEY_PACKAGE_LIST].arrayValue)
        
        return packageList
    }
    
    
    static func with(jsons: [JSON]) -> [MySpotPackages] {
        var packageLists = [MySpotPackages]()
        
        for json in jsons {
            let packageList = MySpotPackages.with(json: json)
            packageLists.append(packageList)
        }
        
        return packageLists
    }
}
