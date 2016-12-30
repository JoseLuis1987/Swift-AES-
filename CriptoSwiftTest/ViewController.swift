//
//  ViewController.swift
//  CriptoSwiftTest
//
//  Created by QACG MAC2 on 12/29/16.
//  Copyright © 2016 QACG MAC2. All rights reserved.
//

import UIKit



//nota el tamaño maximo de la llave es de 32 para 256
//nota el tamaño maximo de la llave es de 24 para 192
//nota el tamaño maximo de la llave es de 16 para 128



class ViewController: UIViewController {
    // 128 bit key
   let aesKey: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
    
    //let key = "thebestsecretkey".utf8.map({$0}) //leng 16
 //   let key = "331FC2C1C10C9B2BFB9673ECEE45462591B66188" //tamaño llave 40

    //PBKDF2WithHmacSHA1

   /*
   let key = "331FC2C1C10C9B2BFB9673ECEE45462591B66188".utf8.map({$0})

    
   let contenido2 = "SPf+hmCMDLGz0xatZzP2o4pzpnN/FDiWk8RGZ0oeBeAqEQFlVEiITetw60r/NfwqlAckG+lOa7h8FjbRwwwqhk684gJOJCE8R3ABjGf4gyjc2KauygL3Qy4ufH08R+IQA7IMhO0g3NueGL+ZR2zQmw".utf8.map({$0})
    let iv: Array<UInt8> = AES.randomIV(AES.blockSize)

    */
    
    
    //32 + 16 48 //256
    //24 + 16 40 // 192
    //16 + 16 32 //128

  
    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonAEncriptar : NSDictionary = [
            "userId" : 23
        ]
        let jsonStringTOEncripted = convertDictionaryToString(json: jsonAEncriptar)
        print(jsonStringTOEncripted)
        print(jsonStringTOEncripted.utf8.map({$0}))
       
        let key = "331FC2C1C10C9B2BFB9673ECEE45462591B66188" // length == 40
        let datakey = Data(bytes: key.utf8.map({$0})) //aplica el hash
        let datakeyhash = datakey.sha256()
        print(datakeyhash)
        print(datakeyhash.count)

        
        
        let iv = "gqLOHUioQ0QjhuvI" // length == 16
        let enc = try! jsonStringTOEncripted.aesEncrypt(key: key, iv: iv)
        let dec = try! enc.aesDecrypt(key: key, iv: iv)
        print("enc:\(enc)") // 2r0+KirTTegQfF4wI8rws0LuV8h82rHyyYz7xBpXIpM=
        print("dec:\(dec)") // string to encrypt
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func convertDictionaryToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            if data1 != nil{
                return String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
            }
            // print(convertedString) // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
}
extension String {
    var drop0xPrefix:          String { return hasPrefix("0x") ? String(characters.dropFirst(2)) : self }
    var drop0bPrefix:          String { return hasPrefix("0b") ? String(characters.dropFirst(2)) : self }
    var hexaToDecimal:            Int { return Int(drop0xPrefix, radix: 16) ?? 0 }
    var hexaToBinaryString:    String { return String(hexaToDecimal, radix: 2) }
    var decimalToHexaString:   String { return String(Int(self) ?? 0, radix: 16) }
    var decimalToBinaryString: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal:          Int { return Int(drop0bPrefix, radix: 2) ?? 0 }
    var binaryToHexaString:    String { return String(binaryToDecimal, radix: 16) }
    
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

extension Int {
    var toBinaryString: String { return String(self, radix: 2) }
    var toHexaString:   String { return String(self, radix: 16) }
}

extension UnicodeScalar {
    var hexNibble:UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}

extension Data {
    init(hex:String) {
        let scalars = hex.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            var nibble = scalar.hexNibble
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        self = Data(bytes: bytes)
    }
}


