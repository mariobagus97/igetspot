////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class IGSService {
    
    struct ErrorAPI: Error {
        let statusCode:Int?
        let message: String
        let userInfo: JSON
    }
    
    let defaultError = ErrorAPI(statusCode: 0,  message: StringConstants.MessageErrorAPI.tryAgainMessage, userInfo: [])
    
    @discardableResult
    func request(httppMethod method: HTTPMethod, baseUrl baseURL: String = IGSEnv.IGetSpotBaseUrl, pathUrl pathURL: String, parameters: [String: Any]? = nil, isAuthenticated: Bool? = true, encoding: ParameterEncoding = URLEncoding.default, success: @escaping (_ apiResponse: MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) -> Request {
        let fullUrlString = "\(baseURL)\(pathURL)"
        
        print("fullurl \(fullUrlString)")
        
        var headers: HTTPHeaders = [
            "User-Agent" : "AppleWebKit/605.1.15 (iPhone; CPU iPhone OS 12_2 like Mac OS X)"
        ]
        if isAuthenticated == true {
            var accessToken = ""
            var tokenType = ""
            if let token = TokenManager.shared.getToken(), let type = TokenManager.shared.getTokenType() {
                accessToken = token
                tokenType = type
            }
            if (accessToken.isEmpty == false) {
                let token = "\(tokenType) \(accessToken)"
                headers["Authorization"] = token
            }
            
        }
        
        
    
        return Alamofire.request(fullUrlString, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseData(completionHandler: { (response) in
            
            PrintDebug.printDebugService(parameters as Any, message: "parameters")
            PrintDebug.printDebugService(fullUrlString, message: "URL")
            PrintDebug.printDebugService(parameters as Any, message: "Parameters")
            PrintDebug.printDebugService(response.response?.statusCode as Any, message: "status code")
            PrintDebug.printDebugService(headers as Any, message: "Headers")
            guard let data = response.data else {
                failure(self.defaultError);
                return
            }
            PrintDebug.printDebugService(String(data:data, encoding: String.Encoding.utf8) ?? "nil", message: "response string")
            switch response.result {
            case .success:
                var responseJSON:JSON = JSON.null
                do {
                    responseJSON = try JSON(data: data)
                } catch {
                    failure(self.defaultError)
                    return
                }
                PrintDebug.printDebugService(responseJSON, message: "Reponse JSON")
                let apiResponse = MKAPIResponse.with(json: responseJSON)
                if (response.response?.statusCode == 200) {
                    success(apiResponse)
                } else if (response.response?.statusCode == 401) {
                    // refresh token
                    self.requestRefreshToken(success: {
                        self.request(httppMethod: method, pathUrl: pathURL, parameters:parameters, success: success, failure: failure)
                    })
                } else if (response.response?.statusCode == 403 ) {
                    // force logout
                    TokenManager.shared.forceLogoutWithAlert()
                } else {
                    let error = ErrorAPI(statusCode: apiResponse.code, message: apiResponse.message, userInfo: responseJSON)
                    failure(error)
                }
            case .failure(let error):
                var callBackError = self.defaultError
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                    // no internet connection
                    callBackError =  ErrorAPI(statusCode:error._code, message: NSLocalizedString("Oops, silakan periksa kembali internet anda dan coba kembali", comment: ""), userInfo: [])
                } else {
                    guard let data = response.data else {failure(self.defaultError); return}
                    var responseJSON:JSON = JSON.null
                    do {
                        responseJSON = try JSON(data: data)
                    } catch {
                        print("Error JSON")
                    }
                    let apiResponse = MKAPIResponse.with(json: responseJSON)
                    if (apiResponse.message == "Error: Invalid user token" ||
                        apiResponse.message == "User already log out" || apiResponse.message == "Unauthorized") {
                        // force logout
                        TokenManager.shared.forceLogoutWithAlert()
                        return
                    } else if (1000 <= apiResponse.code && apiResponse.code <= 7008){
                        callBackError =  ErrorAPI(statusCode:apiResponse.code, message: apiResponse.message, userInfo: responseJSON)
                    } else {
                        if let errorMessage = response.result.error?.localizedDescription {
                            callBackError =  ErrorAPI(statusCode:error._code, message: errorMessage, userInfo: responseJSON)
                        }
                    }
                }
                failure(callBackError)
            }
        })
    }
    
    func uploadMultipart(httppMethod method: HTTPMethod,baseUrl baseURL: String = IGSEnv.IGetSpotBaseUrl, pathURL: String, image:UIImage? = nil, imageName:String? = nil, paramImageName:String? = nil, parameters: [String: Any]? = nil,isAuthenticated: Bool? = true, success:@escaping (_ json: MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        let fullUrlString = "\(baseURL)\(pathURL)"
        
        var headers: HTTPHeaders? = nil
        if isAuthenticated == true {
            var accessToken = ""
            var tokenType = ""
            if let token = TokenManager.shared.getToken(), let type = TokenManager.shared.getTokenType() {
                accessToken = token
                tokenType = type
            }
            if (accessToken.isEmpty == false) {
                headers = ["Authorization": "\(tokenType) \(accessToken)"]
            }
        }
        
        let URL = try! URLRequest(url: fullUrlString, method: method, headers: headers)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let param = parameters {
                for (key, value) in param {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
            let name = paramImageName ?? ""
            let compressedImage = image?.resizeImage(maxWidth: 1000.0, maxHeight: 1000.0)
            if let imageData = compressedImage?.jpegData(compressionQuality: 1.0)?.base64EncodedData() {
                multipartFormData.append(imageData, withName: name)
            }
        }, with: URL, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData{ response in
                    //PrintDebug.printDebugService(parameters as Any, message: "parameters")
                    PrintDebug.printDebugService(fullUrlString, message: "URL")
                    PrintDebug.printDebugService(response.response?.statusCode as Any, message: "status code")
                    PrintDebug.printDebugService(headers as Any, message: "Headers")
                    guard let data = response.data else {
                        failure(self.defaultError);
                        return
                    }
                    PrintDebug.printDebugService(String(data:data, encoding: String.Encoding.utf8) ?? "nil", message: "response string")
                    var responseJSON:JSON = JSON.null
                    do {
                        responseJSON = try JSON(data: data)
                    } catch {
                        failure(self.defaultError)
                        return
                    }
                    PrintDebug.printDebugService(responseJSON, message: "Reponse JSON")
                    let apiResponse = MKAPIResponse.with(json: responseJSON)
                    if (apiResponse.code == 200) {
                        success(apiResponse)
                    } else if (apiResponse.code == 401) {
                        // refresh token
                        self.requestRefreshToken(success: {
                            self.uploadMultipart(httppMethod: method, pathURL: pathURL, success: success, failure: failure)
                        })
                    } else if (apiResponse.code == 500 || apiResponse.message == "Error: Invalid user token" || apiResponse.message == "User already log out") {
                        // force logout
                        TokenManager.shared.forceLogoutWithAlert()
                        
                        return
                    } else {
                        let error = ErrorAPI(statusCode: apiResponse.code, message: apiResponse.message, userInfo: responseJSON)
                        failure(error)
                    }
                }
            case .failure(let error):
                var callBackError = self.defaultError
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
                    // no internet connection
                    callBackError =  ErrorAPI(statusCode:1001, message: NSLocalizedString("Oops, silakan periksa kembali internet anda dan coba kembali", comment: ""), userInfo: [])
                }
                failure(callBackError)
            }
        })
    }
        
}

extension IGSService {
    
    func requestRefreshToken(success: @escaping () -> Void) {
        guard let token = TokenManager.shared.getToken(), let email = TokenManager.shared.getEmail() else {
            // force logout
            TokenManager.shared.forceLogoutWithAlert()
            return
        }
        let parameters = ["email":email,
                          "access_token":token]
        request(httppMethod: .post, pathUrl: "token/refresh", parameters: parameters, isAuthenticated: false, success: { (apiResponse) in
            let json = apiResponse.data
            TokenManager.shared.saveToken(fromJSON: json, email: email)
            success()
        }, failure: { (error) in
            
        })

    }
    
}
