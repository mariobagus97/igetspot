////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class GooglePlace {
    static let KEY_DESCRIPTION = "description"
    static let KEY_ID = "id"
    static let KEY_PLACE_ID = "place_id"
    static let KEY_STRUCTURED_FORMATTING = "structured_formatting"
    static let KEY_MAIN_TEXT = "main_text"
    static let KEY_SECONDARY_TEXT = "secondary_text"

    var description: String?
    var id: String?
    var placeId: String?
    var placeName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    static func with(json: JSON) -> GooglePlace {
        let data = GooglePlace()
        
        if json[KEY_DESCRIPTION].exists(){
            data.description = json[KEY_DESCRIPTION].stringValue
        }
        if json[KEY_ID].exists(){
            data.id = json[KEY_ID].stringValue
        }
        if json[KEY_PLACE_ID].exists(){
            data.placeId = json[KEY_PLACE_ID].stringValue
        }
        if json[KEY_STRUCTURED_FORMATTING][KEY_MAIN_TEXT].exists(){
            data.placeName = json[KEY_STRUCTURED_FORMATTING][KEY_MAIN_TEXT].stringValue
        }
        if json[KEY_STRUCTURED_FORMATTING][KEY_SECONDARY_TEXT].exists(){
            data.address = json[KEY_STRUCTURED_FORMATTING][KEY_SECONDARY_TEXT].stringValue
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [GooglePlace] {
        var googlePlaces = [GooglePlace]()
        
        for json in jsons {
            let place = GooglePlace.with(json: json)
            googlePlaces.append(place)
        }
        
        return googlePlaces
    }
}
