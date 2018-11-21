//
//  JSFileManager.swift
//  JSDownLoadLib
//
//  Created by JS_Coder
//  Copyright © 2017年 JS_Coder. All rights reserved.
//

import UIKit

class JSFileManager: NSObject {
    
    
    /// FilePathExist
    ///
    /// - Parameter filePath: The path of file
    /// - Returns: Bool
    class func fileExist(filePath:String)->Bool {
        if filePath.count == 0{
            return false;
        }
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    
    /// moveFileToDestinoPath
    ///
    /// - Parameters:
    ///   - fromPath: originPath
    ///   - toPath: destinoPath
    class func moveFile(fromPath:String,toPath:String){
        if !fileExist(filePath: fromPath){
            return
        }
        try? FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
        
    }
    
    /// deleteFile
    ///
    /// - Parameter filePath:~~~~~
    class func removeFile(filePath:String){
        if !fileExist(filePath: filePath) {
            return
        }
       try? FileManager.default.removeItem(atPath: filePath)
    }
    
    /// fileSize
    ///
    /// - Parameter filePath: filePath
    /// - Returns: size
    class func fileSize(filePath:String)->Int{
        if !fileExist(filePath: filePath) {
            return 0
        }
        let attribute = try?FileManager.default.attributesOfItem(atPath: filePath)
        let size = attribute?[FileAttributeKey.size] as! Int
      return size
    }
    
    
}
