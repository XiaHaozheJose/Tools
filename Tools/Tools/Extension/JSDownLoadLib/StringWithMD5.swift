//
//  StringWithMD5.swift
//  JSDownLoadLib
//
//  Created by 浩哲 夏 on 2017/3/19.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Foundation
extension String{
    func md5()->String{
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
}
