//
//  String+FormatPrice.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 03/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

extension String {
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "Rp", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ".", with: "")
        if stringWithoutComma.isEmpty == false {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.locale = Locale(identifier: "en_Id")
            formatter.numberStyle = NumberFormatter.Style.currency
            if let result = NumberFormatter().number(from: self), let priceFormatted =  formatter.string(from: result) {
                return priceFormatted.replacingOccurrences(of: "IDR", with: "Rp ")
            }
        }
        
        return "0"
    }
    
    var currencyOnlyDigit: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "Rp", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ".", with: "")
        if stringWithoutComma.isEmpty == false {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.locale = Locale(identifier: "en_Id")
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.maximumFractionDigits = 0
            if let result = NumberFormatter().number(from: stringWithoutComma), let priceFormatted =  formatter.string(from: result) {
                return priceFormatted.replacingOccurrences(of: "IDR", with: "")
            }
        }
        
        return "0"
    }
    
    func formatPriceToDigitString() -> String {
        
        let stringWithoutSymbol = self.replacingOccurrences(of: "Rp", with: "")
        var stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ".", with: "")
        stringWithoutComma = stringWithoutComma.replacingOccurrences(of: " ", with: "")
        return stringWithoutComma
    }
    
    func formatPriceToString() -> String {
        let stringWithoutSymbol = self.replacingOccurrences(of: "Rp", with: "")
        var stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ".", with: "")
        stringWithoutComma = stringWithoutComma.replacingOccurrences(of: " ", with: "")
        return stringWithoutComma.trimmingCharacters(in: .whitespaces)
    }
}
