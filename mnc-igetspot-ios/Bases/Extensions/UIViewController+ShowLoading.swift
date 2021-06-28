////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func showLoadingHUD(_ loadingText : String? = nil) {
        if let loadingMessage = loadingText {
            SVProgressHUD.show(withStatus: loadingMessage)
        } else {
            SVProgressHUD.show()
        }
    }
    
    func hideLoadingHUD() {
        SVProgressHUD.dismiss()
    }
}
