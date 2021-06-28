////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIViewController {
    func showErrorMessageBanner(_ message:String, title:String = "Error") {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.button?.isHidden = true
        error.configureTheme(backgroundColor: Colors.tomatoTwo, foregroundColor: UIColor.white, iconImage: R.image.errorIcon(), iconText: nil)
        error.titleLabel?.font = R.font.barlowMedium(size: 14)!
        error.titleLabel?.textColor = UIColor.white
        error.bodyLabel?.font = R.font.barlowRegular(size: 14)
        error.bodyLabel?.textColor = UIColor.white
        error.configureContent(title: title, body: message)
        
        SwiftMessages.show(view: error)
    }
    
    func showSuccessMessageBanner(_ message:String) {
        let success = MessageView.viewFromNib(layout: .cardView)
        success.button?.isHidden = true
        success.backgroundView.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        success.titleLabel?.font = R.font.barlowMedium(size: 14)!
        success.titleLabel?.textColor = UIColor.white
        success.bodyLabel?.font = R.font.barlowRegular(size: 14)
        success.bodyLabel?.textColor = UIColor.white
        success.configureContent(title: NSLocalizedString("Success", comment: ""), body: message, iconImage: R.image.thumbUp()!)
        SwiftMessages.show(view: success)
    }
    
    /**
        to showing alert popup with two button Cancel and Ok Button
        example to use :
            showAlertMessage(title: "Opps, Error", message: StringConstants.MessageErrorAPI.tryAgainMessage, iconImage: nil, okButtonTitle: "Custom Ok", okAction: {
                // action when user clicked Ok Button
                SwiftMessages.hide()
            }, cancelButtonTitle: "Custom Cancel", cancelAction: {
                // action when user clicked Cancel Button
                SwiftMessages.hide()
            })
    */
    func showAlertMessage(title:String?,
                         message:String?,
                         iconImage: UIImage?,
                         okButtonTitle:String?,
                         okAction:(() -> Void)?,
                         cancelButtonTitle:String?,
                         cancelAction:(() -> Void)?,
                         dismissOnBackground: Bool = true) {
        let view: IGSAlertView = try! SwiftMessages.viewFromNib()
        view.setTitleOkButton(title: okButtonTitle)
        view.okAction = okAction
        view.cancelAction = cancelAction
        view.setTitleCancelButton(title: cancelButtonTitle)
        view.configureNoDropShadow()
        view.configureContent(title: title, body: message, iconImage: iconImage, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: dismissOnBackground)
        SwiftMessages.show(config: config, view: view)
    }
}
