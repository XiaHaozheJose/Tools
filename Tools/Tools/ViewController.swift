//
//  ViewController.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    
    let refresh = JSRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tab = UITableView(frame: view.bounds)
        tab.addSubview(refresh)
        view.addSubview(tab)
        tab.contentInsetAdjustmentBehavior = .always
        refresh.addTarget(self, action: #selector(refreshDidChangedValue), for: .valueChanged)
        
        getDirectoryCache(cacheDir()) { (size) in
            print(size)
        }
    }
    
    @objc func refreshDidChangedValue(){
        // get datas
    }


}

