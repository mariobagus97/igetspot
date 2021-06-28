//
//  MainViewController.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 06/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let menuVC = MenuVC()
        menuVC.delegate = self
        leftViewController = menuVC
        let spaceWidth:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 40 : 60
        leftViewWidth = UIScreen.main.bounds.size.width - spaceWidth
        
        leftView?.applyGradient(colors: [Colors.gradientThemeOne, Colors.gradientThemeTwo], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 1)
        
        leftViewPresentationStyle = .scaleFromBig
        sideMenuController?.rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: .regular)
        sideMenuController?.rootViewCoverAlphaForLeftView = 0.9;
    }

}

extension MainViewController : MenuVCDelegate {
    func onCloseMenu() {
        hideLeftViewAnimated()
    }
    
}
