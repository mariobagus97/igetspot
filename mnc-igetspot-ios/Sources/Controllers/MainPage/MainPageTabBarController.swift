//
//  BottomNavigation.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 9/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit
import LGSideMenuController
import Crashlytics

struct TabBarIndex {
    static let home = 0
    static let chat = 1
    static let order = 2
    static let transaction = 3
    static let myspot = 4
}


class MainPageTabBarController : UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.view.frame.size.width + shadowSize,
                                                   height:
            self.view.frame.size.height + shadowSize))
        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: 10, height: 20.0)
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowPath = shadowPath.cgPath
        
        
//        Crashlytics.sharedInstance().crash()
//        fatalError()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTabBar() {
        self.tabBar.isUserInteractionEnabled = true
        self.tabBar.isTranslucent = false
        
        
        self.delegate = self
        
        let homeController = createNavController(vc: HomeViewController(), selected: R.image.tabHomeActive()!, unselected: R.image.tabHomeInactive()!)
        let chatController = createNavController(vc: ChatListTVC(), selected: R.image.tabChatActive()!, unselected: R.image.tabChatInactive()!)
        let historyController = createNavController(vc: OrderVC(), selected: R.image.tabHistoryActive()!, unselected: R.image.tabHistoryInactive()!)
        let transactionController = createNavController(vc: TransactionTVC(), selected: R.image.tabTransactionActive()!, unselected: R.image.tabTransactionInactive()!)
        let mySpotController = createNavController(vc: PortalMySpotVC(), selected: R.image.tabMasterActive()!, unselected: R.image.tabMasterInactive()!)
        
        viewControllers = [homeController, chatController, historyController, transactionController, mySpotController]
        
        UITabBar.appearance().tintColor = UIKit.UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .white)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: Colors.gray)
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 3, left: 3, bottom: -3, right: -3)
        }
        
        self.tabBar.bringSubviewToFront(self.view)
        self.tabBar.isUserInteractionEnabled = true
    }
}

extension MainPageTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if TokenManager.shared.isLogin() == false && viewController == tabBarController.viewControllers?[TabBarIndex.chat] {
            goToLoginScreen(afterLoginScreenType: .chatTab, afterLoginParameter: nil)
            return false
        } else if TokenManager.shared.isLogin() == false && viewController == tabBarController.viewControllers?[TabBarIndex.transaction] {
            goToLoginScreen(afterLoginScreenType: .transactionsTab, afterLoginParameter: nil)
            return false
        } else if TokenManager.shared.isLogin() == false && viewController == tabBarController.viewControllers?[TabBarIndex.transaction] {
            goToLoginScreen(afterLoginScreenType: .transactionsTab, afterLoginParameter: nil)
            return false
        }
        
        let indexOfNewVC = tabBarController.viewControllers?.index(of: viewController)
        if (tabBarController.selectedIndex == indexOfNewVC) {
            return false
        } else {
            if let navigationController = viewController as? UINavigationController {
                navigationController.popViewController(animated: false)
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBarController.view.setNeedsLayout()
    }
}
