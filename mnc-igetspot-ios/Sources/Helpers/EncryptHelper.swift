//
//  EncryptHelper.swift
//  mnc-igetspot-ios
//
//  Created by Adiputra on 18/09/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import CryptoSwift
import CommonCrypto

class EncryptHelper {
    
    static let key = "taKxovouOF29SyqhgtyQMAuhdhuWo3mG"
    static let iv = "15F1AB77951B5JAO"
    
    static func aesEncrypt(string: String) -> String? {
        var encryptedString: String? = nil
        
        //MARK: - 28/4/20 Disable encryption process
        /*
        do {
            let data = string.data(using: .utf8)
            let enc = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array(iv.utf8)), padding: .pkcs7).encrypt(data!.bytes)
            let encData = NSData(bytes: enc, length: Int(enc.count))
            let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
            encryptedString = String(base64String)
        } catch let error {
            print("aesEncrypt Failed: \(error.localizedDescription)")
            encryptedString = nil
        }
        */
        return encryptedString
    }
}
