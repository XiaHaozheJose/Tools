//
//  UIView-Extension.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit


// MARK: - Toast
extension UIView{
    
    /// Show Alert like Toast android
    ///
    /// - Parameters:
    ///   - text: text will to show
    ///   - showTime: time to display (default = 0.5)
    ///   - dissmissTime: time to disappear (default = 1.5)
    func showToast(withString text: String, _ showTime: Double = 0.5, _ removeTime: Double = 1.5){
        let toast = UILabel()
        toast.numberOfLines = 0
        toast.lineBreakMode = .byWordWrapping
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        toast.textColor = .white
        toast.layer.cornerRadius = 10.0
        toast.layer.masksToBounds = true
        toast.textAlignment = .center
        toast.font = UIFont.systemFont(ofSize: 15)
        toast.text = text
        toast.alpha = 0.0
        
        let maxSize = CGSize(width: self.bounds.width - 40, height: self.bounds.height)
        var expectedSize = toast.sizeThatFits(maxSize)
        var lbWidth = maxSize.width
        var lbHeight = maxSize.height
        if maxSize.width >= expectedSize.width{
            lbWidth = expectedSize.width
        }
        if maxSize.height >= expectedSize.height{
            lbHeight = expectedSize.height
        }
        
        expectedSize = CGSize(width: lbWidth, height: lbHeight)
        toast.frame.size = expectedSize
        toast.center = self.center
        toast.tag = 1008610086
        self.addSubview(toast)
        
        UIView.animate(withDuration: showTime, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            toast.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: removeTime, animations: {
                toast.alpha = 0.0
            }, completion: { (_) in
                toast.removeFromSuperview()
            })
        }
    }
    // remove FromSuperView
   private func removeForceToast(){
        for t in self.subviews{
            if t is UILabel, t.tag == 1008610086{
                t.removeFromSuperview()
            }
        }
    }
}


// MARK: - XY WIDTH HEIGHT SIZE POINT
extension UIView{
    
    /// set x to view
    ///
    /// - Parameter x: x
    func set_x(_ x: CGFloat){
        self.frame.origin.x = x
    }
    
  
    /// get x from view
    ///
    /// - Returns: x
    func get_x() -> CGFloat {
        return self.frame.origin.x
    }
    
    /// set y to view
    ///
    /// - Parameter y: y
    func set_y(_ y: CGFloat){
        self.frame.origin.y = y
    }
    
 
    /// get y from view
    ///
    /// - Returns: y
    func get_y() -> CGFloat {
        return self.frame.origin.y
    }

    /// set width to view
    ///
    /// - Parameter width: width
    func set_width(_ width: CGFloat){
        self.frame.size.width = width
    }
    
   
    /// get width from view
    ///
    /// - Returns: width
    func get_width() -> CGFloat {
        return self.frame.size.width
    }
    
    
    /// set height to view
    ///
    /// - Parameter height: height
    func set_height(_ height: CGFloat){
        self.frame.size.height = height
    }
    
    
    /// get height from view
    ///
    /// - Returns: height
    func get_height() -> CGFloat {
        return self.frame.size.height
    }
    
   
    /// set center x
    ///
    /// - Parameter x: center x
    func set_center_x(_ x: CGFloat){
        self.center.x = x
    }
    
    
    /// get center x from view
    ///
    /// - Returns: center x
    func get_center_x() -> CGFloat {
        return self.center.x
    }
    
    /// set y to view
    ///
    /// - Parameter y: y
    func set_center_y(_ y: CGFloat){
        self.center.y = y
    }
    
  
    /// get center y
    ///
    /// - Returns: center y
    func get_center_y() -> CGFloat {
        return self.center.y
    }
    
    /// set center to view
    ///
    /// - Parameter center: center
    func set_center(_ center: CGPoint){
        self.center = center
    }
    
    
    /// get centerpoint
    ///
    /// - Returns: Center
    func get_center() -> CGPoint {
        return self.center
    }
    
    /// set size to view
    ///
    /// - Parameter size: size
    func set_size(_ size: CGSize){
        self.frame.size = size
    }
    
   
    /// get size from view
    ///
    /// - Returns: size
    func get_size() -> CGSize {
        return self.frame.size
    }
    
    
}
