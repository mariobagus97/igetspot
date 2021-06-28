//
//  GoogleMaps.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/12/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import SwiftyJSON

class GoogleMaps {
    
    static let KEY_CANDIDATES = "candidates"
    
    var candidates : [Candidates]? = [Candidates]()
    
    static func with(json: JSON) -> GoogleMaps {
        let googleMaps = GoogleMaps()
        
        if json[KEY_CANDIDATES].exists(){
            googleMaps.candidates = Candidates.with(jsons: json[KEY_CANDIDATES].arrayValue)
        }
        
        return googleMaps
    }
    
}
