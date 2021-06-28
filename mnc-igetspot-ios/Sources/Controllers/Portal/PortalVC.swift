//
//  PortalVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import LGSideMenuController
import SwiftMessages

class PortalVC: MKViewController {
    
    var mPresenter = PortalPresenter()
    var test : Int!
    var isJailBrokenDevice: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBar()
        self.mPresenter.checkSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mPresenter.attachview(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

extension PortalVC : PortalView {
    
    func goToSignInPage() {
        let signInVC = SignInVC()
        self.navigationController?.pushViewController(signInVC, animated: false)
    }
    
    func showUpdateAlert(){
        showAlertMessage(title: NSLocalizedString("New version available", comment: ""), message: NSLocalizedString("There is a newer version available for download. Please update and enjoy more exciting experiences!", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Update now", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            // temporarily set sample url
            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/magento2-mobikul-mobile-app/id1166583793"),
                UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            }, cancelButtonTitle: NSLocalizedString("Maybe later", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
    func showJailBreakAlert() {
        showAlertMessage(title: NSLocalizedString("Uh-oh.", comment: ""),
                         message: NSLocalizedString("Seems like you jailbreak your phone. Unfortunately, i get Spot won't work on jailbroken device :(", comment:""),
                         iconImage: nil,
                         okButtonTitle: nil,
                         okAction: nil,
                         cancelButtonTitle: nil,
                         cancelAction: nil,
                         dismissOnBackground: false)
    }
    
    func setWalkthroughPage(){
        setRootWalkthroughPage()
    }
    
    func setHomePage(){
        setRootHomePage()
    }
}
