//
//  AESHelper.swift
//  CriptoSwiftTest
//
//  Created by QACG MAC2 on 12/29/16.
//  Copyright © 2016 QACG MAC2. All rights reserved.
//

import Foundation
class AESHelper {
    var key: String
   var iv: String
    
    let BLOCK_SIZE = 16
    init (key: String, iv: String) {
        self.key = key
        self.iv = iv
    }
    func encrypt (stringToEncrypt: String) -> String {
        let messageData = stringToEncrypt.data(using: String.Encoding.utf8)
        let byteArray = pad(value: messageData!.bytes)
        
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC, padding: NoPadding())
        let encrypted = try! aes.encrypt(byteArray)
        
       // let encryptedBytes = try! AES(key: self.key, iv: self.iv, blockMode: .CFB).encrypt(byteArray, padding: NoPadding())
       
        return encrypted.toHexString()
    }
    func decrypt ( message: String) -> String {
        var message = message
        let messageData = message.dataFromHexadecimalString()
        let byteArray = messageData?.bytes
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC, padding: NoPadding())
        let decryptedBytes = try! aes.decrypt(message.utf8.map({$0}))
       // let decryptedBytes: [UInt8] = try! AES(key: self.key, iv: self.iv, blockMode: .CFB).decrypt(byteArray!, padding: NoPadding())
        let unpaddedBytes = unpad(value: decryptedBytes)
        var unencryptedString = NSString(bytes: unpaddedBytes, length: unpaddedBytes.count, encoding: String.Encoding.utf8.rawValue)
        return String(describing: unencryptedString)
    }
    private func pad( value: [UInt8]) -> [UInt8] {
        var value = value
        let length: Int = value.count
        let padSize = BLOCK_SIZE - (length % BLOCK_SIZE)
        let padArray = [UInt8](repeating: 0, count: padSize)
        value.append(contentsOf: padArray)
        return value
    }
    private func unpad( value: [UInt8]) -> [UInt8] {
        var value = value
        
        for i in (0 ..<  value.count - 1).reversed() {
            print(i) // 4,3,2,1,0
            if value[i] == 0 {
                value.remove(at: i)
            } else  {
                break
            }
        }
        
        return value
}
}

extension String {
    /// http://stackoverflow.com/questions/26501276/converting-hex-string-to-nsdata-in-swift
    ///
    /// Create NSData from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a NSData object. Note, if the string has any spaces, those are removed. Also if the string started with a '<' or ended with a '>', those are removed, too. This does no validation of the string to ensure it's a valid hexadecimal string
    ///
    /// The use of `strtoul` inspired by Martin R at http://stackoverflow.com/a/26284562/1271826
    ///
    /// - returns: NSData represented by this hexadecimal string. Returns nil if string contains characters outside the 0-9 and a-f range.
    func dataFromHexadecimalString() -> NSData? {
        let data = NSMutableData(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)
            data?.append(&num, length: 1)
        }
        return data
    }
}


