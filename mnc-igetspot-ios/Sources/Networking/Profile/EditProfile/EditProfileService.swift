////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit

class EditProfileService: IGSService {
    
    func requestEditProfileBasic(_ firstName: String, lastName: String, username: String, birthdate: String, password: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters =  [
            "firstname": firstName,
            "lastname": lastName,
            "username": username,
            "birthdate": birthdate,
            "password": EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        let successApiResponse = { (apiResponse: MKAPIResponse) in
            success(apiResponse)
        }
        
        let pathUrl = "user/profile"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: successApiResponse, failure: failure)
    }
    
    func requestEditProfileAddress(_ address: String, latitude: Double, longitude: Double, detail:String, country:String, city:String, province:String, postcode:String, password:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters =  [
            "address": address,
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "detail":detail,
            "country":country,
            "city":city,
            "province":province,
            "zipcode":postcode,
            "password":EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        let pathUrl = "user/address"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestEditProfilePassword(_ currentPassword: String, newPassword: String, retypePassword:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters =  [
            "current_password": EncryptHelper.aesEncrypt(string: currentPassword) ?? currentPassword,
            "new_password":EncryptHelper.aesEncrypt(string: newPassword) ?? newPassword,
            "retype":EncryptHelper.aesEncrypt(string: retypePassword) ?? retypePassword
        ]
        
        let pathUrl = "user/password"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestEditProfileEmail(_ currentEmail: String, newEmail: String, password:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        
        let parameters =  [
            "current_email": currentEmail,
            "new_email":newEmail,
            "password":EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        let pathUrl = "user/email"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestEditProfilePhone(_ currentPhone: String, newPhone: String, password: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()) {
        let parameters =  [
            "current_phone": EncryptHelper.aesEncrypt(string: currentPhone) ?? currentPhone,
            "new_phone": EncryptHelper.aesEncrypt(string: newPhone) ?? newPhone,
            "password": EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        let pathUrl = "user/phone"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestEditProfileBank(bankId: String, accountHolder: String, accountNumber: String, password: String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        let parameters =  [
            "bank_id": bankId,
            "account_holder": EncryptHelper.aesEncrypt(string: accountHolder) ?? accountHolder,
            "account_no": EncryptHelper.aesEncrypt(string: accountNumber) ?? accountNumber,
            "password": EncryptHelper.aesEncrypt(string: password) ?? password
        ]
        
        let pathUrl = "user/bank"
        self.request(httppMethod: .post, pathUrl: pathUrl, parameters: parameters, success: success, failure: failure)
    }
    
    func requestEditProfileAvatar(_ image: UIImage, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "user/avatar"
        self.uploadMultipart(httppMethod: .post, pathURL: pathUrl, image: image, imageName: "image", paramImageName: "image", isAuthenticated: true, success: success, failure: failure)
    
    }
    
    func requestEditProfileBackgroundImage(_ image: UIImage, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let pathUrl = "user/background"
        self.uploadMultipart(httppMethod: .post, pathURL: pathUrl, image: image, imageName: "image", paramImageName: "image", isAuthenticated: true, success: success, failure: failure)
    }
    
    func requestUserBankDetail(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        self.request(httppMethod: .get, pathUrl: "user/bank/account", success: success, failure: failure)
    }
    
    func deactivateAccount(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
    
    self.request(httppMethod: .post, pathUrl: "user/deactivate", success: success, failure: failure)
    }
}
