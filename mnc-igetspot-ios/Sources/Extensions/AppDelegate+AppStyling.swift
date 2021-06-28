//
//  AppDelegate+AppStyling.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension AppDelegate {
    
    func configureAppStyling() {
        styleNavigationBar()
        styleBarButtons()
        styleSearchBar()
        styleSVProgressHUD()
    }
    
    func styleNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = Colors.blueOne
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : R.font.barlowMedium(size: 14)!,
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
    }
    
    func styleBarButtons() {
        let barButtonItemAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font:  R.font.barlowRegular(size: 14)!,
            NSAttributedString.Key.foregroundColor: Colors.blueTwo
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonItemAttributes, for: .normal)
    }
    
    func styleSearchBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font:  R.font.barlowRegular(size: 14)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        
        
        let barButtonItemAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font:  R.font.barlowMedium(size: 14)!,
            NSAttributedString.Key.foregroundColor: Colors.blueTwo
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(barButtonItemAttributes, for: .normal)
    }
    
    func styleSVProgressHUD() {
        SVProgressHUD.setGradientColors([Colors.gradientThemeTwo.cgColor, Colors.gradientThemeOne.cgColor])
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(Colors.blackAplha38)
        SVProgressHUD.setDefaultStyle(.gradient)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
    }
}
