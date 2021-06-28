////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire

class ChatService: IGSService {
    
    func requestRecentChatList(keyword: String,success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        self.request(httppMethod: .get, pathUrl: "chat/channels?param=\(keyword)", success: success, failure: failure)
    }
    
    func requestChannelRoom(currentUserId:String, opponentId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["user_id":currentUserId, "client_id":opponentId]
        
        self.request(httppMethod: .post, pathUrl: "chat", parameters:parameters, success: success, failure: failure)
    }
    
}
