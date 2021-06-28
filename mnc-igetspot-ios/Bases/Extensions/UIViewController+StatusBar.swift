////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.statusBarUIView {
            if #available(iOS 13.0, *) {
                view.backgroundColor = style == .lightContent ? UIColor.white : .black
////                statusB
//                statusBar.backgroundColor = style == .lightContent ? UIColor.white : .black
            } else {
                statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
            }
        }
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
