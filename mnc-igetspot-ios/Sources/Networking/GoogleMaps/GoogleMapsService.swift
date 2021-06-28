////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GoogleMapsService {
    
    static let BASE_URL = "https://maps.googleapis.com/maps/api"
    static let placeAutocompletePathUrl = "/place/autocomplete/json"
    static let placeDetailPathUrl = "/place/details/json"
    static let reverseGeocodingPathUrl = "/geocode/json"
    
    @discardableResult
    func request(httppMethod method: HTTPMethod, pathUrl pathURL: String, parameters: [String: Any]? = nil, isAuthenticated: Bool? = true, encoding: ParameterEncoding = URLEncoding.default, success: @escaping (_ responseJSON: JSON)->(), failure: @escaping (String)->()) -> Request {
        let fullURL = "\(GoogleMapsService.BASE_URL)\(pathURL)"
        
        return Alamofire.request(fullURL, method: method, parameters: parameters, encoding: encoding).validate().responseData(completionHandler: { (response) in
            
            guard let data = response.data else {
                failure("data null");
                return
            }
            PrintDebug.printDebugService(String(data:data, encoding: String.Encoding.utf8) ?? "nil", message: "response string")
            switch response.result {
            case .success:
                var responseJSON:JSON = JSON.null
                do {
                    responseJSON = try JSON(data: data)
                } catch {
                    failure("json error")
                    return
                }
                success(responseJSON)
            case .failure(let error):
                var callBackError = StringConstants.MessageErrorAPI.tryAgainMessage
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                    // no internet connection
                    callBackError =  NSLocalizedString("Oops, silakan periksa kembali internet anda dan coba kembali", comment: "")
                } else {
                    callBackError = error.localizedDescription
                }
                failure(callBackError)
            }
        })
    }
    
}
