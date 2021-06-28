////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colors: [UIColor], xStartPos: Double, xEndPos: Double, yStartPos: Double, yEndPos: Double) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradient"
        gradient.frame = UIScreen.main.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: xStartPos, y: yStartPos )
        gradient.endPoint = CGPoint(x: xEndPos, y: yEndPos )
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        guard let sublayers = self.layer.sublayers else {
            return
        }
        for layer in sublayers {
            if layer.name == "gradient" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
