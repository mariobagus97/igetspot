//
//  DeviceManager.swift
//  Metube
//
//  Created by Mendhy Syiasko on 5/23/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit

class DeviceManager: NSObject {
    
    static let instance = DeviceManager()
    
    private static let BundleID = "bundleId"
    private static let Identifier = "identifier"
    
    var bundleID: String? {
        get {
            return Bundle.main.bundleIdentifier!
        }
    }
    
    var identifier: String? {
        get {
            return UIDevice.current.identifierForVendor!.uuidString
        }
    }
    
}
