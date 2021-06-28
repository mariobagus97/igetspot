////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotPackage {
    
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_IMAGES = "package_images"
    static let KEY_PACKAGE_PRICE = "package_price"
    
    var id : String?
    var packageName : String?
    var packageImages: String?
    var price : String?
    
    static func with(json: JSON) -> MySpotPackage {
        
        let package = MySpotPackage()
        
        package.id = json[KEY_PACKAGE_ID].stringValue
        package.packageName = json[KEY_PACKAGE_NAME].stringValue
        package.price = json[KEY_PACKAGE_PRICE].stringValue
        package.packageImages = json[KEY_PACKAGE_IMAGES].arrayValue[0].stringValue
        
        return package
    }
    
    
    static func with(jsons: [JSON]) -> [MySpotPackage] {
        var packageArray = [MySpotPackage]()
        
        for json in jsons {
            let package = MySpotPackage.with(json: json)
            packageArray.append(package)
        }
        
        return packageArray
    }
}
