//
//  UserPrefModel.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

class AccountManager {
    
    
    static let instance = AccountManager()
    
    let KEY_IS_SIGNED_IN = "IS_SIGNED_IN"
    //    var userSession: UserSession
    var userSessionData: UserDetailData
    
    let userDefaults: UserDefaults
    
    let KEY_WALKTHROUGH_SHOWN = "walkthroughShown"
    
    var walkthroughShown : Bool = false
    
    private init() {
        self.userDefaults = UserDefaults.standard
        self.userSessionData = UserDetailData()
        
    }
    
    func loadUserSession() -> UserDetailData {
        if(isSignedIn()){
            return getUserSessionData()
        }
        
        return userSessionData
    }
    
    func getUserSessionData() -> UserDetailData {
        let userData = UserDetailData()
        
        userData.uuid = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_UUID)!
        userData.email = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_EMAIL)!
        userData.accessToken = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_ACCESS_TOKEN)!
        userData.id = AccountManager.instance.userDefaults.integer(forKey: UserDetailData.KEY_ID)
        userData.userId = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_USER_ID)!
        userData.rolesId = AccountManager.instance.userDefaults.integer(forKey: UserDetailData.KEY_ROLES_ID)
        userData.idNumber = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_ID_NUMBER)!
        userData.username = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_USERNAME)!
        userData.mastername = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_MASTERNAME)!
        userData.firstname = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_FIRSTNAME)!
        userData.lastname = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_LASTNAME)!
        userData.phone = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_PHONE)!
        userData.address = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_ADDRESS)!
        userData.detail_bulding = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_DETAIL_BUILDING)!
        userData.city = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_CITY)!
        userData.province = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_PROVINCE)!
        userData.country = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_COUNTRY)!
        userData.zipcode = AccountManager.instance.userDefaults.integer(forKey: UserDetailData.KEY_ZIPCODE)
        userData.latitude = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_LATITUDE)!
        userData.longitude = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_LONGITUDE)!
        userData.gender = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_GENDER)!
        userData.birthdate = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_BIRTHDATE)!
        userData.imageUrl = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_IMAGE_URL)!
        userData.balance = AccountManager.instance.userDefaults.integer(forKey: UserDetailData.KEY_BALANCE)
        userData.bank = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_BANK)!
        userData.userLevel = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_USER_LEVEL) ?? ""
        userData.detailAddress = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_DETAIL_ADDRESS) ?? ""
        userData.avatar = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_AVATAR) ?? ""
        userData.backgroundProfile = AccountManager.instance.userDefaults.string(forKey: UserDetailData.KEY_BACKGROUND_PROFILE) ?? ""
        
        return userData
    }
    
    func saveUserSession(userData: UserDetailData){
        if (!isSignedIn()){
            setSignInValue(isSignedIn: true)
            saveUserSessionData(userData: userData)
        }
    }
    
    //    func saveUserSession(userData: UserSessionData){
    //        if (!isSignedIn()){
    //            setSignInValue(isSignedIn: true)
    ////            saveUserSessionData(userData: userData)
    //        }
    //    }
    
    func saveUserSessionData(userData: UserDetailData){
        setSignInValue(isSignedIn: true)
        
        userDefaults.set(userData.uuid, forKey: UserDetailData.KEY_UUID)
        userDefaults.set(userData.email, forKey: UserDetailData.KEY_EMAIL)
        userDefaults.set(userData.accessToken, forKey: UserDetailData.KEY_ACCESS_TOKEN)
        userDefaults.set(userData.id, forKey: UserDetailData.KEY_ID)
        userDefaults.set(userData.userId, forKey: UserDetailData.KEY_USER_ID)
        userDefaults.set(userData.rolesId, forKey: UserDetailData.KEY_ROLES_ID)
        userDefaults.set(userData.idNumber, forKey: UserDetailData.KEY_ID_NUMBER)
        userDefaults.set(userData.username, forKey: UserDetailData.KEY_USERNAME)
        userDefaults.set(userData.mastername, forKey: UserDetailData.KEY_MASTERNAME)
        userDefaults.set(userData.firstname, forKey: UserDetailData.KEY_FIRSTNAME)
        userDefaults.set(userData.lastname, forKey: UserDetailData.KEY_LASTNAME)
        userDefaults.set(userData.phone, forKey: UserDetailData.KEY_PHONE)
        userDefaults.set(userData.address, forKey: UserDetailData.KEY_ADDRESS)
        userDefaults.set(userData.detail_bulding, forKey: UserDetailData.KEY_DETAIL_BUILDING)
        userDefaults.set(userData.city, forKey: UserDetailData.KEY_CITY)
        userDefaults.set(userData.province, forKey: UserDetailData.KEY_PROVINCE)
        userDefaults.set(userData.country, forKey: UserDetailData.KEY_COUNTRY)
        userDefaults.set(userData.zipcode, forKey: UserDetailData.KEY_ZIPCODE)
        userDefaults.set(userData.latitude, forKey: UserDetailData.KEY_LATITUDE)
        userDefaults.set(userData.longitude, forKey: UserDetailData.KEY_LONGITUDE)
        userDefaults.set(userData.gender, forKey: UserDetailData.KEY_GENDER)
        userDefaults.set(userData.birthdate, forKey: UserDetailData.KEY_BIRTHDATE)
        userDefaults.set(userData.imageUrl, forKey: UserDetailData.KEY_IMAGE_URL)
        userDefaults.set(userData.balance, forKey: UserDetailData.KEY_BALANCE)
        userDefaults.set(userData.bank, forKey: UserDetailData.KEY_BANK)
        userDefaults.set(userData.userLevel, forKey: UserDetailData.KEY_BIRTHDATE)
        userDefaults.set(userData.detailAddress, forKey: UserDetailData.KEY_DETAIL_ADDRESS)
        userDefaults.set(userData.avatar, forKey: UserDetailData.KEY_AVATAR)
        userDefaults.set(userData.backgroundProfile, forKey: UserDetailData.KEY_BACKGROUND_PROFILE)
        
    }
    
    func removeUserSession(){
        if (isSignedIn()){
            removeUserSessionData()
        }
    }
    
    func removeUserSessionData(){
        setSignInValue(isSignedIn: false)
        
        
        userDefaults.removeObject(forKey: UserDetailData.KEY_UUID)
        userDefaults.removeObject(forKey: UserDetailData.KEY_EMAIL)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ACCESS_TOKEN)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ID)
        userDefaults.removeObject(forKey: UserDetailData.KEY_USER_ID)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ROLES_ID)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ID_NUMBER)
        userDefaults.removeObject(forKey: UserDetailData.KEY_USERNAME)
        userDefaults.removeObject(forKey: UserDetailData.KEY_MASTERNAME)
        userDefaults.removeObject(forKey: UserDetailData.KEY_FIRSTNAME)
        userDefaults.removeObject(forKey: UserDetailData.KEY_LASTNAME)
        userDefaults.removeObject(forKey: UserDetailData.KEY_PHONE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ADDRESS)
        userDefaults.removeObject(forKey: UserDetailData.KEY_DETAIL_BUILDING)
        userDefaults.removeObject(forKey: UserDetailData.KEY_CITY)
        userDefaults.removeObject(forKey: UserDetailData.KEY_PROVINCE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_COUNTRY)
        userDefaults.removeObject(forKey: UserDetailData.KEY_ZIPCODE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_LATITUDE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_LONGITUDE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_GENDER)
        userDefaults.removeObject(forKey: UserDetailData.KEY_BIRTHDATE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_IMAGE_URL)
        userDefaults.removeObject(forKey: UserDetailData.KEY_BALANCE)
        userDefaults.removeObject(forKey: UserDetailData.KEY_BANK)
        
        print("UserSession Clear")
    }
    
    func setSignInValue(isSignedIn: Bool){
        userDefaults.set(isSignedIn, forKey: AccountManager.instance.KEY_IS_SIGNED_IN)
    }
    
    func isSignedIn() -> Bool {
        if (userDefaults.object(forKey:  AccountManager.instance.KEY_IS_SIGNED_IN) != nil){
//        if (userDefaults.objectIsForced(forKey: AccountManager.instance.KEY_IS_SIGNED_IN)){
            return userDefaults.bool(forKey: AccountManager.instance.KEY_IS_SIGNED_IN)
        } else {
            return false
        }
    }
    
    func updateSessionData (value: String, key: String){
        userDefaults.set(value, forKey: key)
    }
    
    
    func hasWalkthroughShown() -> Bool {
        if (userDefaults.object(forKey:  AccountManager.instance.KEY_WALKTHROUGH_SHOWN) != nil){
            return userDefaults.bool(forKey: AccountManager.instance.KEY_WALKTHROUGH_SHOWN)
        }
        return false
    }
    
    func setWalkthroughValue(value: Bool){
        userDefaults.set(value, forKey: AccountManager.instance.KEY_WALKTHROUGH_SHOWN)
    }
    
}

