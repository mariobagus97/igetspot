//
//  UITabBarControllerExtension.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
        }
    }
    
    func tabBarIsVisible() -> Bool {
        return self.tabBar.frame.origin.y < self.view.frame.maxY
    }
    
    func createNavController(vc: UIViewController, selected: UIImage, unselected: UIImage) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selected.withRenderingMode(.alwaysOriginal)
        
        return navController
    }
}
