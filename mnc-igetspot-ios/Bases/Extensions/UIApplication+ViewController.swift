////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
    
    class func getMainPageTabBarController() -> MainPageTabBarController? {
        guard let appDelegate = AppDelegate.sharedAppDelegate(), let mainViewController = appDelegate.window?.rootViewController as? MainViewController, let mainPageTabBarController = mainViewController.rootViewController as? MainPageTabBarController else {
            return nil
        }
        
        return mainPageTabBarController
    }
}

