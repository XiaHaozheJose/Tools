//
//  JSFileManager.swift
//  JSDownLoadLib
//
//  Created by JS_Coder
//  Copyright © 2017年 JS_Coder. All rights reserved.
//

import UIKit

public class JSDownLoadManager: NSObject{

    deinit {
        
    }
    static let shareInstance:JSDownLoadManager = JSDownLoadManager()
    fileprivate(set) var downLoadInfo:[String:JSDownLoad]? = [:]
    
    
    /// Start to Down With URL
    ///
    /// - Parameters:
    ///   - urlName: url valid
    ///   - statusType: State of download
    ///   - progresesType: download progress
    ///   - totalSize: size of file
    ///   - filePathType: download path
    func downLoadWithInfo(urlName:URL, statusType: ((JSDownLoadState)->())?,progresesType:((Double)->())?,totalSize:((Int)->())?,filePathType:((_ filePath:String)->())?){
        
        let md5 = urlName.absoluteString.md5()
        var downLoader = downLoadInfo?[md5]
        
        if let loader = downLoader {
           loader.resumeCurrentTask()
            return
        }
        
        downLoader = JSDownLoad()
        _ = downLoadInfo?.updateValue(downLoader!, forKey: md5)
        downLoader?.downLoadWithInfo(urlName: urlName, statusType: statusType, progresesType: progresesType, totalSize: totalSize, succesWithFile: { [weak self](filePath:String) in
            _ = self?.downLoadInfo?.removeValue(forKey: md5)
            if let type = filePathType{
                type(filePath)
            }
        })
    }
}

// MARK: - Gestion DownLoad
extension JSDownLoadManager{
    
    /// Resume
    ///
    /// - Parameter url: url
    func resumeWithURL(url:URL){
        commonMd5(url: url)?.resumeCurrentTask()
    }
    
    /// Pause
    ///
    /// - Parameter url: url
    func pauseWithURL(url:URL){
        commonMd5(url: url)?.pauseCurrentTask()
    }
    
    /// Cancel
    ///
    /// - Parameter url: url
    func cancelWithURL(url:URL){
        commonMd5(url: url)?.cancelCurrentTask()
    }
    
    /// Pause All
    func pauseAll(){
        if let downLoadInfo = downLoadInfo{
             for value in downLoadInfo{
            value.value.pauseCurrentTask()
        }
        }
    }
    
    /// Cancel All
    func cancelAll(){
        if let downLoadInfo = downLoadInfo {
            for value in downLoadInfo{
                value.value.cancelCurrentTask()
            }
        }
        
        downLoadInfo?.removeAll()
    }
    
    /// Cancel And Remove
    ///
    /// - Parameter url: url
    func cancelAndCleanWithURl(url:URL){
        commonMd5(url: url)?.cancelAndClean()
        let md5 = url.absoluteString.md5()
       _ = downLoadInfo?.removeValue(forKey: md5)
        
    }
    
    
    
    /// generator md5
    ///
    /// - Parameter url: url
    /// - Returns: request Download
    private func commonMd5(url:URL)->JSDownLoad?{
        let md5 = url.absoluteString.md5()
        return downLoadInfo?[md5]
        
    }
}
