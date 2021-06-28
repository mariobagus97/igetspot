////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SDWebImage

class SDWebImageHelper {
    
    class func removeCacheForIGSImageUrl(imageUrl:String) {
        let imageUrlString = IGSImageUrlHelper.getImageUrl(forPathUrl: imageUrl)
        SDImageCache.shared().removeImage(forKey: imageUrlString, withCompletion: nil)
    }
}
