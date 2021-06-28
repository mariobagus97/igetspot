//
//  UINavigationController+NavigationBar.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        setNavigationBarHidden(false, animated:false)
    }
    
    public func hideNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    public func presentIGSNavigationBar() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage =  UIImage()
        navigationBar.isTranslucent = false
        setNavigationBarHidden(false, animated:false)
    }
}
