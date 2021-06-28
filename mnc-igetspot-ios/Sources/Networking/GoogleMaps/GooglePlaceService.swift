////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GooglePlaceService: GoogleMapsService {
    
    var autocompletePlaceRequest: Request?
    
    func requestAutocompletePlace(input:String, success: @escaping (_ responseJSON:JSON)->(), failure: @escaping (String)->()) {
        
        let parameters = ["input":input,
                          "key":GeneralConstants.GMSServicesAPIKey,
                          "types":"establishment"]
        
        cancelAutocompletePlaceRequest()
        autocompletePlaceRequest = self.request(httppMethod: .get, pathUrl: GoogleMapsService.placeAutocompletePathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestPlaceDetail(placeId:String, success: @escaping (_ responseJSON:JSON)->(), failure: @escaping (String)->()) {
        
        let parameters = ["placeid":placeId,
                          "key":GeneralConstants.GMSServicesAPIKey,
                          "fields":"geometry"]
        
        self.request(httppMethod: .get, pathUrl: GoogleMapsService.placeDetailPathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestReverseGeocoding(latitude:Double, longitude:Double, success: @escaping (_ responseJSON:JSON)->(), failure: @escaping (String)->()) {
        
        let parameters = ["latlng":"\(latitude),\(longitude)",
                          "key":GeneralConstants.GMSServicesAPIKey]
        
        self.request(httppMethod: .get, pathUrl: GoogleMapsService.reverseGeocodingPathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func cancelAutocompletePlaceRequest() {
        autocompletePlaceRequest?.cancel()
    }
}
