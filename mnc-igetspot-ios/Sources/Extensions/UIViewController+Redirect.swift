////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setRootHomePage() {
       
        let mainPageTabBarController = MainPageTabBarController()
        
        let mainViewController = MainViewController()
        mainViewController.rootViewController = mainPageTabBarController
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func setRootWalkthroughPage() {
        let walkthroughVC = WalkthroughVC()
        let navigationController = UINavigationController(rootViewController: walkthroughVC)
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func goToLoginScreen(afterLoginScreenType:AfterLoginScreenType = .none, afterLoginParameter:[String:String]? = nil) {
        let signInVC = SignInVC()
        signInVC.isFromMainTabbar = true
        signInVC.delegate = self
        signInVC.afterLoginParameter = afterLoginParameter
        signInVC.afterLoginScreenType = afterLoginScreenType
        let navigationController = UINavigationController(rootViewController: signInVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension UIViewController: SignInVCDelegate {
    func userHasSuccessfulLoginRegister(afterLoginScreenType:AfterLoginScreenType, afterLoginParameter:[String:String]?) {
        switch afterLoginScreenType {
        case .mySpotRegistration:
            self.navigationController?.popToRootViewController(animated: false)
        case .chatTab:
            if let tabBarController = UIApplication.getMainPageTabBarController() {
                tabBarController.selectedIndex = TabBarIndex.chat
                
            }
        case .orderTab:
            if let tabBarController = UIApplication.getMainPageTabBarController() {
                tabBarController.selectedIndex = TabBarIndex.order
                
            }
        case .transactionsTab:
            if let tabBarController = UIApplication.getMainPageTabBarController(){
                tabBarController.selectedIndex = TabBarIndex.transaction
            }
        case .favorite:
            let mainViewController = sideMenuController!
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let favoriteTVC = FavoriteTVC()
            favoriteTVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(favoriteTVC, animated: true)
        case .wishlist:
            let mainViewController = sideMenuController!
            let tabbarController = mainViewController.rootViewController as! MainPageTabBarController
            let navigationController = tabbarController.selectedViewController as! UINavigationController
            let wishlistTVC = WishlistTVC()
            wishlistTVC.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(wishlistTVC, animated: true)
        case .masterDetail:
            if let viewController = self.navigationController?.viewControllers.last as? MasterDetailVC {
                viewController.getMasterDetail()
            }
        case .packageDetail:
            if let viewController = self.navigationController?.viewControllers.last as? MasterDetailPackageDetailVC {
                viewController.getPackageDetail()
            }
        default:
            break
        }
        // post local notification
        NotificationCenter.default.post(name: NSNotification.Name(kLoginNotificationName), object: nil)
    }
}
