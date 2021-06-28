//
//  MKStore.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 19/01/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MKStoreStatus {
    case none
    case processing
    case interrupted
    case succeed
    case failed
}


class MKStore {
    
    internal var status: MKStoreStatus = .none
    internal var method: Alamofire.HTTPMethod = .get
    internal var path: String = ""
    private var request: Alamofire.Request?
    
    private var overrideParameters: Parameters {
        var params = Parameters()
        return params
    }
    
    internal var overrideHeaders: HTTPHeaders{
        var headers = HTTPHeaders()
        return headers
    }
    
    init() {
    }
    
    internal func reset() {
        
    }
    
    internal func request(headers: HTTPHeaders? = nil, params: Parameters? = nil, encoding: URLEncoding = .default) {
        var actualParameter = Parameters()
        var actualHeaders = HTTPHeaders()
        
        if headers != nil {
            actualHeaders = overrideHeaders.merging(headers!, uniquingKeysWith: {
                (_, last) in last
            })
        } else {
            actualHeaders = actualHeaders.merging(overrideHeaders, uniquingKeysWith: {
                (_, last) in last
            })
        }
        
        if params != nil {
            actualParameter = overrideParameters.merging(params!, uniquingKeysWith: {
                (_, last) in last
            })
        } else {
            actualParameter = actualParameter.merging(overrideParameters, uniquingKeysWith: {
                (_, last) in last
            })
        }
        
        
        let url: URL = URL(string: IGSEnv.IGetSpotBaseUrl + self.path)!
        status = .processing
        
        print("headers :\(headers)")
        
        request = Alamofire.request(url, method: self.method, parameters: actualParameter, encoding: encoding, headers: actualHeaders).responseJSON { response in
            
            
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                let apiResponse = MKAPIResponse.with(json: json)
                print("apiResponse success url :\(url) \n:\(json)")
                if apiResponse.code == 200 {
                    if apiResponse.data.count>0 {
                        self.status = .succeed
                        self.onSuccess(apiResponse)
                    } else {
                        self.status = .failed
                        if let message = json["message"].string {
                            self.onFailure(response.response?.statusCode ?? 500, message: message)
                        } else if json["message"].exists(){
                            self.onFailure(apiResponse.code, message: apiResponse.message)
                        } else {
                            self.onFailure(apiResponse.code, message: apiResponse.data.stringValue)
                        }
                    }
                } else {
                    self.onFailure(apiResponse.code, message: apiResponse.message)
                }
            } else {
                print(response.result)
                print(response.response)
                self.status = .failed
                if let errorMessage = response.result.error?.localizedDescription {
                    self.onFailure(400, message: errorMessage)
                } else {
                    self.onFailure(999, message: "Internal error, Please try again later")
                }
            }
        }
        
        
//        guard let httpBody = request?.body.HTTPBody else { return }
//        do {
//            if let jsonParams = try JSONSerialization.JSONObjectWithData(httpBody, options: []) as? [String: AnyObject] {
//                if let objectId = jsonParams["firstname"] {
//                    print("firstname param: \(objectId)")
//                }
//            }
//        } catch {
//            print(error)
//        }
    }
    
    func cancel() {
        self.status = .interrupted
        request?.cancel()
    }
    
    func onSuccess(_ apiResponse: MKAPIResponse) {
        logger("onSuccess(\(apiResponse.code))")
    }
    
    func onFailure(_ errorCode: Int, message: String) {
        logger("onFailure(\(errorCode)-\(message))")
    }
    
    func logger(_ message: String) {
        print("MKStore Log: \(message)")
    }
}
