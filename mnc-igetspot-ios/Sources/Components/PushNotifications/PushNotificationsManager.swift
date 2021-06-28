////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import PushNotifications

class PushNotificationsManager {
    
    var payloadDictionary : [AnyHashable: Any]?
    let beamsClient = PushNotifications.shared
    
    static let shared = PushNotificationsManager()
    
    fileprivate init() { //This prevents others from using the default '()' initializer for this class.
    }
    let IGSAuthBeamsUrl = "https://stag-api.igetspot.com/api/notification/pusher/beams-auth/"
    
    func setupToken() {
        if TokenManager.shared.isLogin(), let userId = TokenManager.shared.getUserId() {
            print("setupToken userId :\(userId)")
            let authBeamsUrl = "\(IGSAuthBeamsUrl)\(userId)"
            print("authBeamsUrl :\(authBeamsUrl)")
            let tokenProvider = BeamsTokenProvider(authURL: authBeamsUrl) { () -> AuthData in
                let headers: [String: String] = [:]// Headers your auth endpoint needs
                let queryParams: [String: String] = [:] // URL query params your auth endpoint needs
                return AuthData(headers: headers, queryParams: queryParams)
            }
            
            self.beamsClient.setUserId(userId, tokenProvider: tokenProvider, completion: { error in
                guard error == nil else {
                    print("error beamsClient setUserId : \(error.debugDescription)")
                    return
                }
                
                print("Successfully authenticated with Pusher Beams")
            })
        }
    }
    
    func setupDeviceInterestUser() {
        if TokenManager.shared.isLogin(), let userId = TokenManager.shared.getUserId() {
            try? beamsClient.addDeviceInterest(interest: userId)
        }
    }
    
    func removeDeviceInterestUser() {
        if TokenManager.shared.isLogin(), let userId = TokenManager.shared.getUserId() {
            try? beamsClient.removeDeviceInterest(interest: userId)
        }
    }
    
    func setPayload(_ payload:[AnyHashable: Any]!) {
        payloadDictionary = nil
        payloadDictionary = payload
    }
    
    func showNotificationAlertWithMessage() {
        guard let payloadDictionary = self.payloadDictionary, let apsDictionary = payloadDictionary[PushNotificationsConstant.PushNotificationPayload.aps] as? [AnyHashable: Any],
            let alertDictionary = apsDictionary[PushNotificationsConstant.PushNotificationPayload.alert] as? [AnyHashable: Any],
            let dataDictionary = apsDictionary[PushNotificationsConstant.PushNotificationPayload.data] as? [AnyHashable: Any],
            let notificationType = dataDictionary[PushNotificationsConstant.PushNotificationDataField.pushNotificationType] as? String else {
                return
        }
        let title = alertDictionary[PushNotificationsConstant.PushNotificationPayload.title] as? String ?? NSLocalizedString("Push Notification", comment: "")
        let bodyMessage = alertDictionary[PushNotificationsConstant.PushNotificationPayload.body] as? String ?? ""
        
        if (notificationType ==  PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderRequest) {
            
            let success = MessageView.viewFromNib(layout: .cardView)
            success.button?.isHidden = true
            success.backgroundView.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
            success.titleLabel?.font = R.font.barlowMedium(size: 14)!
            success.titleLabel?.textColor = UIColor.white
            success.bodyLabel?.font = R.font.barlowRegular(size: 14)
            success.bodyLabel?.textColor = UIColor.white
            success.configureContent(title: title, body: bodyMessage, iconImage: R.image.thumbUp()!)
            success.tapHandler = { _ in
                SwiftMessages.hide()
                self.executeCurrentPayload(true)
            }
            SwiftMessages.show(view: success)
        }
    }
    
    func executeCurrentPayload(_ animated:Bool) {
        guard let payloadDictionary = self.payloadDictionary,
            let apsDictionary = payloadDictionary[PushNotificationsConstant.PushNotificationPayload.aps] as? [AnyHashable: Any],
            let dataDictionary = apsDictionary[PushNotificationsConstant.PushNotificationPayload.data] as? [AnyHashable: Any],
            let notificationType = dataDictionary[PushNotificationsConstant.PushNotificationDataField.pushNotificationType] as? String
                else {
                PrintDebug.printDebugGeneral(self, message: "either payloadDictionary nil or notificationType value nil")
                return
                }
        
        guard let appDelegate = AppDelegate.sharedAppDelegate(), let mainViewController = appDelegate.window?.rootViewController as? MainViewController, let rootViewController = mainViewController.rootViewController as? MainPageTabBarController else {
            PrintDebug.printDebugGeneral(self, message: "root view controller is not MainViewController")
            return
        }
        if (rootViewController.presentedViewController != nil) {
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        let navigationController = rootViewController.selectedViewController as? UINavigationController
        navigationController?.popToRootViewController(animated: false)
        let pushNotificationReceiverId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.receiverId] as? String
        let userId = TokenManager.shared.getUserId()
        let isLogin = pushNotificationReceiverId == userId
        if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderRequest) {
            // redirect to master order request detail
            rootViewController.selectedIndex = TabBarIndex.myspot
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            let mySpotRequestOrderPagerVC = MySpotRequestOrderPagerVC()
            mySpotRequestOrderPagerVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(mySpotRequestOrderPagerVC, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let packageId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.packageId] as? String
                let orderId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.orderId] as? String
                    let orderRequestDetailTVC = MySpotOrderRequestDetailTVC()
                    orderRequestDetailTVC.packageId = packageId
                    orderRequestDetailTVC.orderId = orderId
                    orderRequestDetailTVC.delegate = mySpotRequestOrderPagerVC
                    mySpotRequestOrderPagerVC.navigationController?.pushViewController(orderRequestDetailTVC, animated: false)
                }
            
         } else if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderConfirmation) {
            // redirect to transaction waiting
            rootViewController.selectedIndex = TabBarIndex.transaction
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            if let transactionTVC = navigationController?.viewControllers.first as? TransactionTVC {
                if (transactionTVC.pagingViewController != nil) {
                    transactionTVC.openWaitingTabAndRefreshData()
                }
            }
        } else if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderPaymentUser) {
            // open payment success user
            rootViewController.selectedIndex = TabBarIndex.transaction
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            if let transactionTVC = navigationController?.viewControllers.first as? TransactionTVC {
                if (transactionTVC.pagingViewController != nil) {
                    transactionTVC.openActiveTabAndRefreshData()
                }
                if let txId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.txId] as? String {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        transactionTVC.showPaymentSuccess(txId: txId, isFromPushNotifications:true)
                    }
                }
            }
        } else if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderPaymentMaster) {
            // open payment success master
            rootViewController.selectedIndex = TabBarIndex.myspot
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            let mySpotRequestOrderPagerVC = MySpotRequestOrderPagerVC()
            mySpotRequestOrderPagerVC.selectIndex = 1
            mySpotRequestOrderPagerVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(mySpotRequestOrderPagerVC, animated: false)
            
        } else if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeServiceSuccess) {
            // open review page
            rootViewController.selectedIndex = TabBarIndex.transaction
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            if let transactionTVC = navigationController?.viewControllers.first as? TransactionTVC {
                if (transactionTVC.pagingViewController != nil) {
                    transactionTVC.openActiveTabAndRefreshData()
                }
                if let packageId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.packageId] as? String, let orderId = dataDictionary[PushNotificationsConstant.PushNotificationDataField.orderId] as? String {
                    let transactionDetailTVC = TransactionDetailTVC()
                    transactionDetailTVC.packageId = packageId
                    transactionDetailTVC.orderId = orderId
                    transactionDetailTVC.hidesBottomBarWhenPushed = true
                    transactionTVC.navigationController?.pushViewController(transactionDetailTVC, animated: true)
                }
            }
        } else if (notificationType == PushNotificationsConstant.PushNotificationType.kPushNotificationTypeOrderSuccess) {
            // open master success order page
            rootViewController.selectedIndex = TabBarIndex.myspot
            let navigationController = rootViewController.selectedViewController as? UINavigationController
            let mySpotRequestOrderPagerVC = MySpotRequestOrderPagerVC()
            mySpotRequestOrderPagerVC.selectIndex = 2
            mySpotRequestOrderPagerVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(mySpotRequestOrderPagerVC, animated: false)
        }
    }
    
    func executePushNotificationSendbird(_ payload:[AnyHashable: Any]) {
        guard let appDelegate = AppDelegate.sharedAppDelegate(), let mainViewController = appDelegate.window?.rootViewController as? MainViewController, let rootViewController = mainViewController.rootViewController as? MainPageTabBarController else {
            PrintDebug.printDebugGeneral(self, message: "root view controller is not MainViewController")
            return
        }
        
        if (rootViewController.presentedViewController != nil) {
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        let navigationController = rootViewController.selectedViewController as? UINavigationController
        navigationController?.popToRootViewController(animated: false)
        
        rootViewController.selectedIndex = TabBarIndex.chat
        
        guard let currentUserId = TokenManager.shared.getUserId(), let senderDict = payload["sender"] as? [AnyHashable: Any], let senderId = senderDict["id"] as? String, let selectedNavController = rootViewController.selectedViewController as? UINavigationController, let firstViewController = selectedNavController.viewControllers.first else {
            return
        }
        
        ChatManager.shared.goToChannelRoom(userId: currentUserId, opponentId: senderId, viewController: firstViewController)
    }
}
