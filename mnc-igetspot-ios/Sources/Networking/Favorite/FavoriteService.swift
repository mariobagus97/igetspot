////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

enum FavoriteEditType: String {
    case save = "save"
    case remove = "remove"
}

class FavoriteService: IGSService {
    
    func requestAllFavorites(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "user/favorites", success: success, failure: failure)
    }
    
    func requestEditFavorites(masterId:String, favoriteEditType:FavoriteEditType, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters = ["user_fav_id":masterId]
        
        var pathUrl = ""
        switch favoriteEditType {
        case .save:
            pathUrl = "user/favorites"
            self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
        case .remove:
            pathUrl = "user/favorites/\(masterId)"
            self.request(httppMethod: .delete, pathUrl: pathUrl, success: success, failure: failure)
        }
    }
}
