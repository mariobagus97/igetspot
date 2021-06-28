//
//  AppDelegate.swift
//  mnc-igetspot-ios
//
//  Created by Rohmat Suseno on 10/08/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SkeletonView
import SwiftDate
import SDWebImage
import PushNotifications
import SwiftMessages
import SendBirdSDK
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Styling NavigationBar, BarButtonItem, SearchBar
        configureAppStyling()
        
        GMSServices.provideAPIKey(GeneralConstants.GMSServicesAPIKey)
        GMSPlacesClient.provideAPIKey(GeneralConstants.GMSServicesAPIKey)
        
        //facebook sign in
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize sign-in google
        GIDSignIn.sharedInstance().clientID = GeneralConstants.googleSignInClientID
        
        // SDWebImage
        SDImageCache.shared().config.maxCacheAge = 3600 * 24 * 7 //1 Week
        SDImageCache.shared().maxMemoryCost = 1024 * 1024 * 20 //Aprox 20 images
        SDImageCache.shared().config.shouldCacheImagesInMemory = false //Default True => Store images in RAM cache for Fast performance
        SDImageCache.shared().config.shouldDecompressImages = false
        SDWebImageDownloader.shared().shouldDecompressImages = false
        SDImageCache.shared().config.diskCacheReadingOptions = NSData.ReadingOptions.mappedIfSafe
        
        // Swift Date
        SwiftDate.defaultRegion = Region.local
        
        // Migration Version
        let versionManager = VersionManager()
        versionManager.checkForUpdatedVersion()
        
        // Login Sendbird
        ChatManager.shared.startConnectSendbird()
        
        // Push Notifications
        setupPushNotifications()
        PushNotificationsManager.shared.setupDeviceInterestUser()
        registerForPushNotifications()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
//        Fabric.sharedSDK().debug = true
        
        // set first screen
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: PortalVC())
        return true
    }
    
    @available(iOS 9.0, *)
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled = false
        
        if (url.scheme?.hasPrefix("fb"))! {
            handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        } else {
            handled = GIDSignIn.sharedInstance().handle(url)
        }
        
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handled = false
        
        if (url.scheme?.hasPrefix("fb"))! {
            handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            handled = GIDSignIn.sharedInstance().handle(url)
        }
        
        return handled
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        AppEvents.activateApp()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        
        // Profile
        UserProfileManager.shared.requestProfileUser()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Push Notifications
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
        SBDMain.registerDevicePushToken(deviceToken, unique: true) { (status, error) in
            if error == nil {
                if status == SBDPushTokenRegistrationStatus.pending {
                    print("token registration is pending")
                    // Registration is pending.
                    // If you get this status, invoke `+ registerDevicePushToken:unique:completionHandler:` with `[SBDMain getPendingPushToken]` after connection.
                }
                else {
                    print("token registration is success")
                    // Registration succeeded.
                }
            }
            else {
                
                print("token registration is failed")
                // Registration failed.
            }
        }

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if var sendBirdPayload = notification["sendbird"] as? [AnyHashable : Any]{
            switch application.applicationState {
            case .inactive, .background:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // The app was launched by the user tapping a notification
                    PushNotificationsManager.shared.executePushNotificationSendbird(sendBirdPayload)
                    completionHandler(.newData)
                }
            case .active:
                // show popup message push notifications
                print("didReceiveRemoteNotification sendbird active")
            default:
                break
            }
        } else {
            switch application.applicationState {
            case .inactive, .background:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // The app was launched by the user tapping a notification
                    PushNotificationsManager.shared.setPayload(notification)
                    PushNotificationsManager.shared.executeCurrentPayload(false)
                    completionHandler(.newData)
                }
            case .active:
                // show popup message push notifications
                PushNotificationsManager.shared.setPayload(notification)
                PushNotificationsManager.shared.showNotificationAlertWithMessage()
                completionHandler(.newData)
            default:
                break
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL else { return false }
    
        guard let itemURL = NSURL(string: url.absoluteString),
            let components = itemURL.pathComponents, components.count > 1 else { return false}
        
        if(presentVC(path: components[1], url: url.absoluteString)){
            return true
        } else {
            application.open(url)
        }
        
        return false
    }
    
    // MARK: shared delegate
    class func sharedAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate;
    }
    
    
    func setupPushNotifications() {
        self.pushNotifications.start(instanceId: GeneralConstants.pusherId)
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: "all-igetspot")
    }
    
    func presentVC(path: String, url: String) -> Bool{
        if(path.contains(RouteHandler.resetPassword)){
            let test = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let finalUrl = URL(string: test!)!
            let appToken = finalUrl.valueOf("app_token")
            let token = appToken?.components(separatedBy: " ").first
            
            let resetVC = ResetPasswordVC()
            resetVC.token = token ?? ""
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = UINavigationController(rootViewController: resetVC)
            return true
        }
        
        return false
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }


}

