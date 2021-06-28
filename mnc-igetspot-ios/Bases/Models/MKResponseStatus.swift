//
//  MKResponseStatus.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 20/12/17.
//  Copyright © 2017 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON
// no longer needed
class MKResponseStatus {
    var code: Int = 0
    var messageServer: String = ""
    var messageClient: String = ""
    var message: String = ""
    
    static func with(json: JSON) -> MKResponseStatus {
        let status = MKResponseStatus()
        
        if json["code"].exists() {
            status.code = json["code"].intValue
        }
        if json["message_client"].exists() {
            status.messageClient = json["message_client"].stringValue
        }
        if json["message_server"].exists() {
            status.messageServer = json["message_server"].stringValue
        }
        if json["message"].exists(){
            status.message = json["message"].stringValue
        }
        
        return status
    }
    
    func isSuccess() -> Bool {
        return 200 <= code && code < 300
    }
}
