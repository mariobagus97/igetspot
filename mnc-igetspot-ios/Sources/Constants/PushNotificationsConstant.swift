////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

struct PushNotificationsConstant {
    
    struct PushNotificationPayload {
        static let aps = "aps"
        static let alert = "alert"
        static let title = "title"
        static let body = "body"
        static let data = "data"
    }
    
    struct PushNotificationType {
        static let kPushNotificationTypeOrderRequest = "ORDERREQUEST"
        static let kPushNotificationTypeOrderConfirmation = "ORDERCONFIRMATION"
        static let kPushNotificationTypeOrderPaymentUser = "ORDERPAYMENTUSER"
        static let kPushNotificationTypeOrderPaymentMaster = "ORDERPAYMENTMASTER"
        static let kPushNotificationTypeServiceSuccess = "SERVICESUCCESS"
        static let kPushNotificationTypeOrderSuccess = "ORDERSUCCESS"
        
    }
    
    struct PushNotificationDataField {
        static let pushNotificationType = "NotifEvent"
        static let orderId = "OrderID"
        static let packageId = "PackageID"
        static let packageName = "PackageName"
        static let userId = "UserId"
        static let receiverId = "ReceiverId"
        static let userType = "UserType"
        static let username = "Username"
        static let txId = "Txid"
    }
    
}
