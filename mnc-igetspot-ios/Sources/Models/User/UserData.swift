//
//  UserData.swift
//  mnc-igetspot-ios
//
//  Created by Adiputra on 01/10/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class UserData: Object {
    @objc dynamic var userId: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var backgroundProfile: String = ""
    @objc dynamic var idNumber: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var mastername: String = ""
    @objc dynamic var firstname: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var province: String = ""
    @objc dynamic var zipcode: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var birthDate: String = ""
    @objc dynamic var balance: Int = 0
    @objc dynamic var bankId: String = ""
    @objc dynamic var bankName: String = ""
    @objc dynamic var accountHolder: String = ""
    @objc dynamic var accountNo: String = ""
    @objc dynamic var isMaster: Bool = false
    @objc dynamic var isActive: Bool = false
    
    convenience required init(withJSON json :JSON) {
        self.init()
    
        self.userId = json["user_id"].stringValue
        self.email = json["email"].stringValue
        self.avatar = json["avatar"].stringValue
        self.backgroundProfile = json["background"].stringValue
        self.idNumber = json["idnumber"].stringValue
        self.username = json["username"].stringValue
        self.mastername = json["mastername"].stringValue
        self.firstname = json["firstname"].stringValue
        self.lastname = json["lastname"].stringValue
        self.phone = json["phone"].stringValue
        self.address = json["address"]["address"].stringValue
        self.notes = json["address"]["notes"].stringValue
        self.country = json["address"]["country"].stringValue
        self.city = json["address"]["city"].stringValue
        self.province = json["address"]["province"].stringValue
        self.zipcode = json["address"]["zipcode"].stringValue
        self.latitude = json["address"]["latitude"].doubleValue
        self.longitude = json["address"]["longitude"].doubleValue
        self.birthDate = json["birthdate"].stringValue
        self.balance = json["balace"].intValue
        self.bankId = json["bank_name"].stringValue
        self.bankName = json["bank_name"].stringValue
        self.accountHolder = json["account_holder"].stringValue
        self.accountNo = json["account_no"].stringValue
        self.isMaster = json["is_master"].boolValue
        self.isActive = json["is_active"].boolValue
    }
    
    override class func primaryKey() -> String? {
        return "userId"
    }
}
