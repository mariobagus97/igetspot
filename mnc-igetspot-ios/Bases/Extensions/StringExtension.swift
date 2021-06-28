//
//  StringExtension.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 24/05/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encode() -> String {
        let str = self
        if let utf8str = str.data(using: String.Encoding.utf8){
            return utf8str.base64EncodedString()
        }
        return ""
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                       options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isPhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg","jpeg","png","gif"]
        
        if URL(string: self) != nil  {
            let extensi = (self as NSString).pathExtension
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    /*
     if let base64Decoded = NSData(base64EncodedString: base64Encoded, options:   NSDataBase64DecodingOptions(rawValue: 0))
     .map({ NSString(data: $0, encoding: NSUTF8StringEncoding) })
     {
     // Convert back to a string
     print("Decoded:  \(base64Decoded)")
     }
     */
}
