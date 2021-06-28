//
//  ParentProtocol.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 13/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

@objc protocol ParentProtocol:class {
    func showLoading()
    func hideLoading()
    @objc optional func showSuccessMessage(_ message: String)
    @objc optional func showErrorMessage(_ message: String)
    @objc optional func showEmpty(_ message: String,_ buttonTitle: String?)
}
