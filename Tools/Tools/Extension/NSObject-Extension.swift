//
//  NSObject-Extension.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Foundation

// MARK: - Get Directory
extension NSObject{
    
    /// get cache directory
    ///
    /// - Returns: Directory path
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        return path!
    }
    
    /// get document directory
    ///
    /// - Returns: Directory path
    func documentDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return path!
    }
    
    
    /// get temp directory
    ///
    /// - Returns: Directory path
    func TmpDir() -> String {
        let path = NSTemporaryDirectory()
        return path
    }
    
    
    /// get folder size by path
    ///
    /// - Parameters:
    ///   - path: file path o directory path
    ///   - completion: closure -> return file size
    func getDirectoryCache(_ path: String, completion:((_ fileSize: Int)->())?){
        // get filemanager
        let manager = FileManager.default
        var isDirectory: ObjCBool = false // ObjcBool
        let isExist = manager.fileExists(atPath: path, isDirectory: &isDirectory)
        
        // Check not Exist o not directory
        if !isExist || !isDirectory.boolValue{
            let exception = NSException(name: NSExceptionName(rawValue: "File Path No Valid"), reason: "Need a path and effective path, Check your path", userInfo: nil)
            exception.raise()
        }
        // open a queue to calculate
        OperationQueue().addOperation {
            var totalSize: Int = 0
            if let subPaths = manager.subpaths(atPath: path) {
                for sub in subPaths{
                    let filePath = path + "/" + sub
                    if filePath.contains(".DS") {continue}
                    var subIsDirectory: ObjCBool = false
                    let isExist = manager.fileExists(atPath: filePath, isDirectory: &subIsDirectory)
                    
                    if !isExist || subIsDirectory.boolValue{ continue }
                    
                    // get attribute of file
                    do{
                       let attr = try manager.attributesOfItem(atPath: filePath)
                        if let size = attr[FileAttributeKey.size] as? Int {
                            totalSize += size
                        }
                    }catch let error {
                        let exception = NSException(name: NSExceptionName(rawValue: "\(error.localizedDescription)"), reason: "other error", userInfo: nil)
                        exception.raise()
                    }
                }}
            // back to main queue
            OperationQueue.main.addOperation({
                completion?(totalSize)
            })
        }}
    
    
    /// remove all file in folder
    ///
    /// - Parameters:
    ///   - path: folder path
    ///   - completion: finished , It's better to recalculate here
    func cleanFolder(_ path: String, completion: ((_ finished: Bool)->())?){
        let manager = FileManager.default
        if let subPaths = manager.subpaths(atPath: path) {
            OperationQueue().addOperation {
                    for sub in subPaths{
                        let filePath = path + "/" + sub
                        if filePath.contains(".DS") {continue}
                        var subIsDirectory: ObjCBool = false
                        let isExist = manager.fileExists(atPath: filePath, isDirectory: &subIsDirectory)
                        if !isExist || subIsDirectory.boolValue{ continue }
                        try? manager.removeItem(atPath: filePath)
                    }
            }
            OperationQueue.main.addOperation {
                completion?(true)
            }
        }
    }
    
    
    
    
}
