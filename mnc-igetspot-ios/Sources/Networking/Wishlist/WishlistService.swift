////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

enum WishlistEditType: String {
    case save = "save"
    case remove = "remove"
}

class WishlistService: IGSService {
    
    func requestAllWishlist(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "user/wishlist", success: success, failure: failure)
    }
    
    func requestEditWishlist(packageId:String, wishlistEditType:WishlistEditType, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["package_id":packageId]
        
        var pathUrl = ""
        switch wishlistEditType {
        case .save:
            pathUrl = "user/wishlist"
            self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
        case .remove:
            pathUrl = "user/wishlist/\(packageId)"
            self.request(httppMethod: .delete, pathUrl: pathUrl, success: success, failure: failure)
        }
    }
    
}
