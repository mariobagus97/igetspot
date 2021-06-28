//
//  UIViewController+Xib.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
