////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftMessages

class PrintDebug {
    
    class func printDebugService (_ object:Any, message:String) {
        #if DEBUG_SERVICE_MODE
            print("\(message): \(object)")
        #endif
    }
    
    class func printDebugGeneral(_ object:Any, message:String) {
        #if DEBUG_GENERAL_MODE
            print("\(message): \(object)")
        #endif
    }
    
    class func showPopUpLog(title:String, message:String) {
        let view: IGSAlertView = try! SwiftMessages.viewFromNib()
        view.setTitleOkButton(title: "CLOSE")
        view.okAction = { SwiftMessages.hide() }
        view.cancelAction = nil
        view.setTitleCancelButton(title: nil)
        view.configureNoDropShadow()
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
}
