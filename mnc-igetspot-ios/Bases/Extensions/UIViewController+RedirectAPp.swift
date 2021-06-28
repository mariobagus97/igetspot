//
//  UIViewController+RedirectAPp.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 22/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func openApp(gotoUrl: String, appScheme: String) {
        let appUrl = URL(string: appScheme)
        
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            UIApplication.shared.open(appUrl!)
        } else {
            guard let url = URL(string: gotoUrl) else { return }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
        
    }
}
