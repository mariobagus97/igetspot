//
//  ForgetPasswordStore.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/21/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol MapsStoreDelegate {
    func mapsStoreSuccess(candidateList : [Candidates])
    func mapsStoreFailed(errorCode: Int, message: String)
}

class MapsStore: MKStore {
    let thisPath = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=formatted_address,name,geometry&key=AIzaSyBzIjlyas4Uf477Sm6zA5HOWodyGhTv0qk"
    
    var delegate: MapsStoreDelegate!
    
    let MAPSAPI = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"
    let KEY_INPUT = "input"
    let KEY_INPUT_TYPE = "inputtype=textquery&fields=formatted_address,name,geometry&key="
    
    
    override init(){
        super.init()
    }
    
    func call(keyword: String) {
        self.path = MAPSAPI + KEY_INPUT + "=" + keyword + KEY_INPUT_TYPE + "AIzaSyBzIjlyas4Uf477Sm6zA5HOWodyGhTv0qk"

        do {
            let request = try URLRequest(url: self.path, method: .get)
        
            Alamofire.request(request).responseJSON(completionHandler: { (response) in
                if response.result.error == nil {
                    
                    print(response)
                    let json = JSON(response.result.value!)
                    let apiResponse = GoogleMaps.with(json: json)
                    
                    if apiResponse.candidates?.count ?? -1 > 0 {
                        
                        self.delegate?.mapsStoreSuccess(candidateList: apiResponse.candidates!)
                        
                    } else {
                       
                    }
                    
                    
                } else {
                }
            })
        } catch {
            //            self.delegate?.mySpotWhatToOfferStoreFailed(message: error)
            print(error)
        }
    }
    
}
