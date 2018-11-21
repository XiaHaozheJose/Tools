//
//  ViewController.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var progress: UIProgressView!

  deinit {
    print(ViewController.description())

  }

  let url = URL.init(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")

  override func viewDidLoad() {
    super.viewDidLoad()


  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    JSDownLoadManager.shareInstance.downLoadWithInfo(urlName:url!, statusType: nil, progresesType: {
      (progress) in
      print(progress)
    }, totalSize: nil, filePathType: { (file) in
      print(file)
    })
  }

  @IBAction func startDownLoad() {

    JSDownLoadManager.shareInstance.downLoadWithInfo(urlName:url!, statusType: nil, progresesType: {[weak self]
      (fileProgress) in
      self?.progress.progress = Float(fileProgress)
      }, totalSize: nil, filePathType: { (file) in
        print(file)
    })

  }
  @IBAction func resume() {
    JSDownLoadManager.shareInstance.resumeWithURL(url: url!)
  }
  @IBAction func pauseDown() {
    JSDownLoadManager.shareInstance.pauseWithURL(url: url!)
  }
  @IBAction func cancel() {
    JSDownLoadManager.shareInstance.cancelWithURL(url: url!)


  }
  @IBAction func cancelAndClean() {
    JSDownLoadManager.shareInstance.cancelAndCleanWithURl(url: url!)

  }
}
