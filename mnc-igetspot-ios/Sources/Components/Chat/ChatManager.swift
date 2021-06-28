////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit
import SendBirdSDK
import PushNotifications

let ErrorDomainConnection = "id.mncdigital.igetspot.connection"
let ErrorDomainUser = "id.mncdigital.igetspot.user"

protocol ChatManagerConnectionDelegate: NSObjectProtocol {
    func didConnect(isReconnection: Bool)
    func didDisconnect()
}

class ChatManager : NSObject {
    
    var observers: NSMapTable<NSString, AnyObject> = NSMapTable(keyOptions: .copyIn, valueOptions: .weakMemory)
    static let shared = ChatManager()
    var chatService: ChatService!
    
    fileprivate override init() { //This prevents others from using the default '()' initializer for this class.
        super.init()
        SBDMain.initWithApplicationId(GeneralConstants.sendbirdAppId)
        SBDMain.setLogLevel(SBDLogLevel.info)
        SBDMain.add(self as SBDConnectionDelegate, identifier: self.description)
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
        chatService = ChatService()
    }
    
    deinit {
        SBDMain.removeConnectionDelegate(forIdentifier: self.description)
        SBDMain.removeChannelDelegate(forIdentifier: self.description)
    }
    
    // MARK: - Public Functions
    func startConnectSendbird() {
        if let userId = TokenManager.shared.getUserId() {
            login(userId: userId) { (user, error) in
                if let theError: NSError = error {
                    print("startConnectSendbird : \(theError.localizedDescription)")
                    return
                }
                print("startConnectSendbird nickname :\(user?.nickname ?? "nil")")
            }
        }
    }
    
    func login(userId: String, completionHandler: ((_ user: SBDUser?, _ error: NSError?) -> Void)?) {
        SBDMain.connect(withUserId: userId) { (user, error) in
            if let theError: NSError = error {
                if let handler = completionHandler {
                    var userInfo: [String: Any] = Dictionary()
                    if let reason: String = theError.localizedFailureReason {
                        userInfo[NSLocalizedFailureReasonErrorKey] = reason
                    }
                    userInfo[NSLocalizedDescriptionKey] = theError.localizedDescription
                    userInfo[NSUnderlyingErrorKey] = theError
                    let connectionError: NSError = NSError.init(domain: ErrorDomainConnection, code: theError.code, userInfo: userInfo)
                    handler(nil, connectionError)
                }
                return
            }
            SBDOptions.setUseMemberAsMessageSender(true)
            self.setupPushToken()
            
            if let handler = completionHandler {
                handler(user, nil)
            }
        }
    }
    
    // MARK: - Private Functions
    func logout(completionHandler: (() -> Void)?) {
        
        SBDMain.disconnect {
            self.broadcastDisconnection()
            
            if let handler: () -> Void = completionHandler {
                handler()
            }
        }
        UIApplication.shared.unregisterForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
        SBDMain.unregisterAllPushToken(completionHandler: { (response, error) in
            if error != nil { // Error.
                return
            }
        })
    }
    
    func goToChannelRoom(userId:String, opponentId:String, viewController:UIViewController) {
        viewController.showLoadingHUD()
        chatService.requestChannelRoom(currentUserId: userId, opponentId: opponentId, success: { (apiResponse) in
            viewController.hideLoadingHUD()
            let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                
                let chatVC = ChatVC(chatterName:nickName , chatterUserId: opponentId, sendbirdChannelUrl: channelUrl, chatterImageUrl: profileImageUrl, phoneNumber:phoneNumber)
                chatVC.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(chatVC, animated: true)
            } else {
                viewController.showErrorMessageBanner(NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            }, failure: { (error) in
                viewController.hideLoadingHUD()
                viewController.showErrorMessageBanner(error.message)
        })
    }
    
    private func setupPushToken() {
        if let pushToken: Data = SBDMain.getPendingPushToken() {
            SBDMain.registerDevicePushToken(pushToken, unique: true, completionHandler: { (status, error) in
                guard let _: SBDError = error else {
                    print("APNS registration failed.")
                    return
                }
                
                if status == .pending {
                    print("Push registration is pending.")
                }
                else {
                    print("APNS Token is registered.")
                }
            })
        }
    }
    
    func add(connectionObserver: ChatManagerConnectionDelegate) {
        self.observers.setObject(connectionObserver as AnyObject, forKey:ChatManager.instanceIdentifier(instance: connectionObserver))
        if SBDMain.getConnectState() == .open {
            connectionObserver.didConnect(isReconnection: false)
        }
        else if SBDMain.getConnectState() == .closed {
            startConnectSendbird()
        }
    }
    
    func remove(connectionObserver: ChatManagerConnectionDelegate) {
        let observerIdentifier: NSString = ChatManager.instanceIdentifier(instance: connectionObserver)
        self.observers.removeObject(forKey: observerIdentifier)
    }
    
    private func broadcastConnection(isReconnection: Bool) {
        let enumerator: NSEnumerator? = self.observers.objectEnumerator()
        while let observer = enumerator?.nextObject() as! ChatManagerConnectionDelegate? {
            observer.didConnect(isReconnection: isReconnection)
        }
    }
    
    private func broadcastDisconnection() {
        let enumerator: NSEnumerator? = self.observers.objectEnumerator()
        while let observer = enumerator?.nextObject() as! ChatManagerConnectionDelegate? {
            observer.didDisconnect()
        }
    }
    
    static private func instanceIdentifier(instance: Any) -> NSString {
        return NSString(format: "%zd", self.hash())
    }
}

// MARK: - SBDChannelDelegate
extension ChatManager: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        
    }
}

// MARK: - SBDConnectionDelegate
extension ChatManager: SBDConnectionDelegate {
    func didStartReconnection() {
        self.broadcastDisconnection()
    }
    
    func didSucceedReconnection() {
        self.broadcastConnection(isReconnection: true)
    }
    
    func didFailReconnection() {
        //
    }
    
    func didCancelReconnection() {
        //
    }
}
