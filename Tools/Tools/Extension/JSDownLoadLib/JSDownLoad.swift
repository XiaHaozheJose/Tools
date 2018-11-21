//
//  JSFileManager.swift
//  JSDownLoadLib
//
//  Created by JS_Coder
//  Copyright © 2017年 JS_Coder. All rights reserved.
//

import UIKit



enum JSDownLoadState:Int {
    case JSDownLoadStatePause = 0
    case JSDownLoadStateDownLoading = 1
    case JSDownLoadStateSuccess = 2
    case JSDownLoadStateFailed = 3
}


let kCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
let kTempPath = NSTemporaryDirectory()

class JSDownLoad: NSObject {

    deinit {
        
    }
    /*
     Session of lazy
     */
    fileprivate lazy var session: URLSession? = {
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    //dataTask
    fileprivate  var dataTask: URLSessionDataTask?
    fileprivate  var outputStream : OutputStream?
    fileprivate var downLoadingFile:String = ""
    fileprivate  var downLoadedFile:String = ""
    fileprivate var tempSize: Int = 0
    
    /// 状态
    fileprivate(set) var state:JSDownLoadState = .JSDownLoadStatePause{
        didSet{
            if oldValue == state {
                return
            }
            if let type = stateType {
                type(state)
            }
            if state == .JSDownLoadStateSuccess {
                if let type = filePathType {
                    type(downLoadedFile)
                }
            }
            if state == .JSDownLoadStateFailed {
            }
        }
    }
    
    fileprivate(set) var progress:Double = 0{
        didSet{
            if let type = progressType{
                type(progress)
            }
        }
    }
    
    fileprivate(set)  var totalSize: Int = 0{
        didSet{
            if let type = totalSizeType{
                type(totalSize)
            }
        }
    }
    fileprivate(set) var stateType:((_ state: JSDownLoadState)->())?
    fileprivate(set) var progressType:((_ progress: Double)->())?
    fileprivate(set) var totalSizeType:((_ totalSize: Int)->())?
    fileprivate(set) var filePathType:((_ filePath: String)->())?

    func downLoadWithInfo(urlName:URL, statusType: ((JSDownLoadState)->())?,progresesType:((Double)->())?,totalSize:((Int)->())?,succesWithFile:((_ filePath:String)->())?){
        stateType = statusType
        progressType = progresesType
        totalSizeType = totalSize
        filePathType = succesWithFile
        downLoad(urlName: urlName)
    }
    
    /// downLoad
    ///
    /// - Parameter urlName
    func downLoad(urlName:URL) {
        if let url = dataTask?.originalRequest?.url {
            if urlName == url {
                if state == .JSDownLoadStatePause {
                    resumeCurrentTask()
                    return
                }}}
        
        cancelCurrentTask()
        let fileName = urlName.lastPathComponent
        downLoadingFile = kTempPath.appending("\(fileName)")
        downLoadedFile = kCachePath.appending("/\(fileName)")
        
        
        if JSFileManager.fileExist(filePath: downLoadedFile) {
            state = .JSDownLoadStateSuccess
        }
        
        if !JSFileManager.fileExist(filePath: downLoadingFile) {
            downLoadWithURL(url: urlName, rangeOffset: 0)
            return
        }
        
        tempSize = JSFileManager.fileSize(filePath: downLoadingFile)
        downLoadWithURL(url: urlName, rangeOffset: tempSize)
    }
}

// MARK: - Request
extension JSDownLoad{
    fileprivate func downLoadWithURL(url:URL,rangeOffset:Int){
        
        var request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
        request.setValue("bytes=\(rangeOffset)-", forHTTPHeaderField: "Range")
        dataTask = session?.dataTask(with: request)
        resumeCurrentTask()
    }
    
    
    /// 恢复当前下载
    func resumeCurrentTask(){
        if state == .JSDownLoadStatePause && dataTask != nil{
            dataTask?.resume()
            state = .JSDownLoadStateDownLoading
        }
    }
    
    /// 暂停当前下载
    func pauseCurrentTask(){
        if state == .JSDownLoadStateDownLoading {
            state = .JSDownLoadStatePause
            dataTask?.suspend()
            outputStream?.close()
        }
    }
    
    /// 取消当前下载
    func cancelCurrentTask(){
        state = .JSDownLoadStatePause
        dataTask?.suspend()
        outputStream?.close()
//        if let data = dataTask {
//            session?.invalidateAndCancel()
//        }
    }
    
    /// 取消并删除当前下载
    func cancelAndClean(){
        cancelCurrentTask()
        JSFileManager.removeFile(filePath: downLoadingFile)
        session?.invalidateAndCancel()
        outputStream?.close()
    }
    
}

// MARK: - URLSessionDelegate
extension JSDownLoad:URLSessionDataDelegate{
    
    /// Receive Response Not receive content  第一次接收到响应时调用，没有具体资源内容
    ///
    /// - Parameters:
    ///   - session: session 会话
    ///   - dataTask: task 任务
    ///   - response: info response 响应头信息
    ///   - completionHandler: handle 回调 (cencel ,取消，resume,继续 ...)
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        //get httpResponse
        var httpResponse = HTTPURLResponse()
        httpResponse = response as! HTTPURLResponse
        // get Content-Length
        let contentLenght:NSString = (httpResponse.allHeaderFields["Content-Length"] as! NSString)
        totalSize = Int(contentLenght.intValue)
        //if Content-Range is not nil get size with Content-Range
        let contentRange = httpResponse.allHeaderFields["Content-Range"] as! NSString
        if contentRange.length != 0 {
            let range = contentRange.components(separatedBy: "/").last!
            let rangeStr = range as NSString
            totalSize = Int(rangeStr.intValue)
        }
        
        if tempSize == totalSize {
            //移动文件夹到cache
            JSFileManager.moveFile(fromPath:downLoadingFile, toPath:downLoadedFile)
            completionHandler(.cancel)
            state = .JSDownLoadStatePause
            return
        }
        
        if tempSize > totalSize {
            //remove tempFile(downLoadingFile)
            JSFileManager.removeFile(filePath:downLoadingFile)
            completionHandler(.cancel)
            guard let url = response.url else {return}
            downLoad(urlName:url)
            return
        }
        state = .JSDownLoadStateDownLoading
        outputStream = OutputStream.init(toFileAtPath: downLoadingFile, append: true)
        outputStream?.open()
        completionHandler(.allow)
    }
    
    /// get data  接收数据时调用
    ///
    /// - Parameters:
    ///   - session: 会话
    ///   - dataTask: 任务
    ///   - data: 数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let nsData = data as NSData
        let bytes = nsData.bytes.assumingMemoryBound(to:UInt8.self)
        tempSize += nsData.length
        progress = (1.0 * Double(tempSize)) / Double(totalSize)
        outputStream?.write(bytes, maxLength: nsData.length)
      
    }
    
    
    /// 会话完成
    ///
    /// - Parameters:
    ///   - session: 会话
    ///   - task: 任务
    ///   - error: 是否失败
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            JSFileManager.moveFile(fromPath: downLoadingFile, toPath: downLoadedFile)
            state = .JSDownLoadStateSuccess
            if let type = filePathType{
                type(downLoadedFile)
            }

        }else{
            let nsError = error as! NSError
            if -999 == nsError.code {
                state = .JSDownLoadStatePause
            }else{
                state = .JSDownLoadStateFailed
                session.invalidateAndCancel()
            }
        }
        outputStream?.close()
    }
}
