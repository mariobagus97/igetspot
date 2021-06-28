////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftyJSON
import SVProgressHUD


let kLoginNotificationName = "LoginNotification"

class TokenManager {
    let accessTokenKeychainName = "accessToken"
    let emailKeychainName = "email"
    let userIdKeychainName = "uuid"
    let tokenTypeKeychainName = "tokenType"
    
    static let shared = TokenManager()
    
    fileprivate init() { //This prevents others from using the default '()' initializer for this class.
    }
    
    let keychain = Keychain(service: "IGSToken")
    
    func saveToken(fromJSON json:JSON, email: String) {
        let token = json["access_token"].stringValue
        let tokenType = json["token_type"].stringValue
        let id = json["user_id"].stringValue
        let email = email
        
        UIApplication.shared.registerForRemoteNotifications()
        saveToken(token, email: email, uuid: id, tokenType: tokenType)
        PushNotificationsManager.shared.setupDeviceInterestUser()
        
        // Login Sendbird
        ChatManager.shared.login(userId: id, completionHandler: nil)
    }
    
    func saveToken(_ token: String, email:String, uuid:String, tokenType: String) {
        keychain[accessTokenKeychainName] = token
        keychain[emailKeychainName] = email
        keychain[userIdKeychainName] = uuid
        keychain[tokenTypeKeychainName] = tokenType
    }
    
    // MARK: Get data
    
    func getToken() -> String? {
        return keychain[accessTokenKeychainName]
    }
    
    func getTokenType() -> String? {
        return keychain[tokenTypeKeychainName]
    }
    
    func getUserId() -> String? {
        return keychain[userIdKeychainName]
    }
    
    func getEmail() -> String? {
        return keychain[emailKeychainName]
    }
    
    func isLogin() -> Bool {
        let token = getToken()
        
        if (token == nil || token?.count == 0) {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Delete
    func clearDataKeychain() {
        do {
            try keychain.removeAll()
        } catch {}
    }
    
    func clearAllData() {
        clearDataKeychain()
        DataManager.shared.deleteAll(UserData.self)
    }
    
    // MARK: - Logout
    func forceLogoutWithAlert() {
        if (!isLogin()) {
            return
        }
        
        logOut(isForceLogout:true)
    }
    
    
    func logOut(isForceLogout:Bool = false, isDeactivated: Bool = false) {
        
        // remove device interest user id
        PushNotificationsManager.shared.removeDeviceInterestUser()
        
        // delete data user
        clearAllData()
        
        // Disconnect Sendbird
        ChatManager.shared.logout(completionHandler: nil)
        
        SVProgressHUD.dismiss()
        
        if let appDelegate = AppDelegate.sharedAppDelegate() {
            
            guard let mainViewController = appDelegate.window?.rootViewController as? MainViewController, let rootViewController = mainViewController.rootViewController as? MainPageTabBarController else {
                #if DEBUG_GENERAL_MODE
                print("root view controller is not MainViewController")
                #endif
                return
            }
            
            if (rootViewController.presentedViewController != nil) {
                rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            if let navigationController = rootViewController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: false)
            }
            rootViewController.selectedIndex = TabBarIndex.home
            if let navigationController = rootViewController.selectedViewController as? UINavigationController {
                if (navigationController.presentedViewController != nil) {
                    navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                navigationController.popToRootViewController(animated: false)
            }
            if (isDeactivated){
                rootViewController.showErrorMessageBanner(NSLocalizedString("Your Account has been deactivated", comment: ""), title: "")
            } else {
                if (isForceLogout)  {
                    rootViewController.showErrorMessageBanner(NSLocalizedString("Your session not valid. Please login again", comment: ""), title: "Logout")
                } else {
                    rootViewController.showSuccessMessageBanner(NSLocalizedString("You have been Logout", comment: ""))
                }
            }
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(kLoginNotificationName), object: nil)
        }
    }
}
