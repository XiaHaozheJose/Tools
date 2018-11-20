//
//  UIColor-Extension.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit

extension UIColor{
    
    /// RandomColor
    ///
    /// - Returns: UIColor
    class func randomColor()->UIColor{
        return UIColor.init(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    // MARK: - RGB
    /// Initial With RGBA
    ///
    /// - Parameters:
    ///   - r: Red
    ///   - g: Green
    ///   - b: Blue
    ///   - alpha: Alpha
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    // MARK: - 处理16进制
    /// initial with Hex
    ///
    /// - Parameter hexString: "#FFFFFF"
    convenience init?(hexString:String) {
        //处理16进制 0x 0X #
        guard hexString.count > 6 else {return nil }
        var hexTempString = hexString.uppercased() as NSString
        
        //判断0X
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##"){
            hexTempString = hexTempString.substring(from: 2) as NSString
            // hexTempString = hexTempString.substring(from: hexTempString.index(hexString.startIndex, offsetBy: 2))
        }
        //判断#
        if hexTempString.hasPrefix("#"){
            hexTempString = hexTempString.substring(from: 1) as NSString
        }
        //截取R:FF G:00 B:11
        var range = NSRange.init(location: 0, length: 2)
        let rHex = hexTempString.substring(with: range)
        var red : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&red)
        
        range.location = 2
        let gHex = hexTempString.substring(with: range)
        var green : UInt32 = 0
        Scanner(string: gHex).scanHexInt32(&green)
        
        range.location = 4
        let bHex = hexTempString.substring(with: range)
        var blue : UInt32 = 0
        Scanner(string: bHex).scanHexInt32(&blue)
        self.init(r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue))
    }
}
// MARK: - Get RGB with one RGB color
extension UIColor{
    ///通过RGB值通道 获取RGB
    func getRGBWithRGBColor()->(CGFloat,CGFloat,CGFloat){
        guard  let cmps = cgColor.components else {
            fatalError("MUST BE RGB COLOR")
        }
        return (cmps[0] * 255,cmps[1] * 255,cmps[2] * 255)
    }
    
    
    /// Get RGB with one color
    ///
    /// - Returns: RGB 
    func getRGBWithColor()->(CGFloat,CGFloat,CGFloat){
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}

