////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor?, withFont font:UIFont?) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        if let fontColor = color {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        }
        if let fontType = font {
            self.addAttribute(NSAttributedString.Key.font, value: fontType, range: range)
        }
    }
    
}


