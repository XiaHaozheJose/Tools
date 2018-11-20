//
//  String-Extension.swift
//  Tools
//
//  Created by 浩哲 夏 on 2017/3/19.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Foundation


// MARK: - EnCryption
extension String{
    
    /// Get Md5 With String
    /// #import <CommonCrypto/CommonCrypto.h> to the ObjC-Swift bridging header that Xcode creates.
    /// - Returns: hash
    func getMd5() -> String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str,strLen,result)
        var hash:String = ""
        for i in 0..<digestLen{
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return hash
    }
    
    /// Get SHA1 With String
    /// #import <CommonCrypto/CommonCrypto.h> to the ObjC-Swift bridging header that Xcode creates.
    /// - Returns: hash
    func getSha1String() -> String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(str,strLen,result)
        var hash:String = ""
        for i in 0..<digestLen{
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return hash
    }
    
}


