//
//  GoogleMaps.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/12/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class Candidates {
    
    static let KEY_FORMATTED_ADDRESS = "formatted_address"
    static let KEY_GEOMETRY = "geometry"
    static let KEY_NAME = "name"
    
    //geometry
    static let KEY_LOCATION = "location"
    static let KEY_LAT = "lat"
    static let KEY_LNG = "lng"
    
    var formattedAddress : String? = ""
    var name : String? = ""
    
    var lat : Double? = 0.0
    var lng : Double? = 0.0
    
    static func with(json: JSON) -> Candidates {
        let candidates = Candidates()
        
        if json[KEY_FORMATTED_ADDRESS].exists(){
            candidates.formattedAddress = json[KEY_FORMATTED_ADDRESS].stringValue
        }
        if json[KEY_GEOMETRY].exists(){
            let geometry = json[KEY_GEOMETRY].arrayValue
            
            let parsedGeometry = parseGeometry(geometry: geometry)
            
            if (parsedGeometry != nil) {
                candidates.lat = parsedGeometry.lat
                candidates.lng = parsedGeometry.lng
            }

        }
        
        if json[KEY_NAME].exists(){
            candidates.name = json[KEY_NAME].stringValue
        }
        
        return candidates
    }
    
    static func parseGeometry(geometry: [JSON]) -> Candidates{
        
        var candidates : Candidates!
        
            for item in geometry {
                candidates = Candidates()
                
                if item[KEY_LAT].exists(){
                    candidates.lat = item[KEY_LAT].doubleValue
                }
                if item[KEY_LNG].exists(){
                    candidates.lng = item[KEY_LNG].doubleValue
                }
            }
        
        return candidates
    }
    
   
    static func with(jsons: [JSON]) -> [Candidates] {
        var candidatesList = [Candidates]()
        
        for json in jsons {
            let candidate = Candidates.with(json: json)
            candidatesList.append(candidate)
        }
        
        return candidatesList
    }
    
}
