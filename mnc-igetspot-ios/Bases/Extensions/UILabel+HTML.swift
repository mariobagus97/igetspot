////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); color: \(self.textColor.toHexString());font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
//        DispatchQueue.main.async {[weak self] in
        self.attributedText = attrStr
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
////            print("text \(attrStr)")
//            self.attributedText = attrStr
//        }
    }
}

extension UITextView {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); color: \(self.textColor?.toHexString());font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
