//
//  MKResponseMeta.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 06/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON
// no longer needed
class MKResponseMeta {
    
    var total: NSNumber?
    var perPage: Int = 0
    var currentPage: Int = 1
    var lastPage: Int?
    var form: Int = 0
    var to: Int = 0
    
    static func with(json: JSON) -> MKResponseMeta {
        let meta = MKResponseMeta()
        
        meta.total = json["total"].number
        meta.perPage = json["per_page"].intValue
        meta.currentPage = json["current_page"].intValue
        meta.lastPage = json["last_page"].int
        meta.form = json["form"].intValue
        meta.to = json["to"].intValue
        
        
        return meta
    }
}
