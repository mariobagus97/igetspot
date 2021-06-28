////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class IGSImageUrlHelper {
    
    class func getImageUrl(forPathUrl pathUrlString:String) -> String {
        var domainImageAPI = ""
        if ((pathUrlString.hasPrefix(ServiceConstants.URL.Path.apiBlogImage)) ||
            (pathUrlString.hasPrefix(ServiceConstants.URL.Path.apiServiceImage))) {
            domainImageAPI = IGSEnv.IGSImageStaticBaseUrl
        } else if (pathUrlString.hasPrefix(ServiceConstants.URL.Path.apiImage)) {
            domainImageAPI = IGSEnv.IGSImageBaseUrl
        } else if (pathUrlString.hasPrefix(ServiceConstants.URL.Path.apiAuthImage)) {
            domainImageAPI = IGSEnv.IGSImageAuthBaseUrl
        }
        
        var imageUrlString = ""
        if let urlEncoding = pathUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if domainImageAPI.isEmpty {
                imageUrlString = urlEncoding
            } else {
                imageUrlString = domainImageAPI + urlEncoding
            }
        }
        
        return imageUrlString
    }
    
}
