////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotPackageImage {
    
    static let KEY_PACKAGE_IMAGE_ID = "package_image_id"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    
    var imageId : String?
    var imageUrl : String?
    var image : UIImage?
    
    static func with(json: JSON) -> MySpotPackageImage {
        
        let packageImage = MySpotPackageImage()
        
        packageImage.imageId = json[KEY_PACKAGE_IMAGE_ID].stringValue
        packageImage.imageUrl = json[KEY_PACKAGE_IMAGE_URL].stringValue
        
        return packageImage
    }
    
    static func with(jsons: [JSON]) -> [MySpotPackageImage] {
        var packageImageArray = [MySpotPackageImage]()
        
        for json in jsons {
            let packageImage = MySpotPackageImage.with(json: json)
            packageImageArray.append(packageImage)
        }
        
        return packageImageArray
    }
}
