//
//  UIImage-Extension.swift
//  Tools
//
//  Created by JS_Coder on 11/20/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import UIKit

extension UIImage{
    
    
    /// RRegenerate the image according to size
    ///
    /// - Parameter size: new size you want
    /// - Returns: new image
    open func imageWithNewSize(size: CGSize) -> UIImage? {
        
        if self.size.height > size.height {
            
            let width = size.height / self.size.height * self.size.width
            
            let newImgSize = CGSize(width: width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
            
        } else {
            
            let newImgSize = CGSize(width: size.width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
        }
        
    }
    
    
    
    /// For QRCode transform to custom size image
    /// - Parameters:
    ///   - image: outPutImage
    ///   - size: SizeForImage
    /// - Returns: UIimage
    class func createClearImage(_ image: CIImage, size: CGFloat) -> UIImage?{
        // 1.获取图片的尺寸,并调整小数像素到整数像素,将origin下调(12.3->12),size上调(11.5->12)
        // get image frame
        let extent = image.extent.integral
        
        // 2.取出指定大小的最小比例
        // get min scale between custom size and image size
        let scale = min(size / extent.width, size/extent.height)
        
        // 3.将图片放大到指定比例
        // scale image
        let width = extent.width * scale
        let height = extent.height * scale
        
        // 3.1创建依赖于设备的灰度颜色通道
        // get a Gray Space by Device
        let cs = CGColorSpaceCreateDeviceGray();
        
        // 3.2创建位图上下文
        // get CGContext
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)
        
        // 4.创建上下文
        //get CIContext
        let context = CIContext(options: nil)
        
        // 5.将CIImage转为CGImage
        // change CIImage to CGImage
        let bitmapImage = context.createCGImage(image, from: extent)
        
        // 6.设置上下文渲染等级
        // set quelity for context
        bitmapRef!.interpolationQuality = .none
        
        // 7.设置缩放比例
        // set scale for context
        bitmapRef?.scaleBy(x: scale, y: scale)
        
        // 8.绘制一张图片在位图上下文中
        // draw image in context
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        // 9.从位图上下文中取出图片(CGImage)
        // get a image by context
        guard let scaledImage = bitmapRef?.makeImage() else {return nil}
        
        // 10.将CGImage转为UIImage并返回
        // return the image scaled
        return UIImage(cgImage: scaledImage)
    }
    
    
    /// Get image with one color
    ///
    /// - Parameter color: UIColor
    /// - Returns: UIImage?
    class func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // open ImageContext
        UIGraphicsBeginImageContext(rect.size)
        // get context
       let context = UIGraphicsGetCurrentContext()
        // set fill color for context
        context?.setFillColor(color.cgColor)
        // set fill color with rect
        context?.fill(rect)
        // get image with context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // close ImageContext
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Clip Image to Cycle Image with border
    ///
    /// - Parameters:
    ///   - borderWidth: border width
    ///   - color: border color
    /// - Returns: cycle image
    func clipToCycle(withBorder borderWidth: CGFloat, withColor color: UIColor) -> UIImage?{
        // get image size
        let size = CGSize(width: self.size.width + borderWidth, height: self.size.height + borderWidth)
        
        // begin ImageContext
        UIGraphicsBeginImageContext(size)
        
        // bezierPath with oval
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        color.set()
        bezierPath.fill()
        
        // bezierPath to clip
        let clipPath = UIBezierPath(ovalIn: CGRect(x: borderWidth, y: borderWidth, width: self.size.width, height: self.size.height))
        
        clipPath.addClip()
        // draw border
        self.draw(at: CGPoint(x: borderWidth, y: borderWidth))
        // get image from context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // close context
        UIGraphicsEndImageContext()
        return image
    }
    
    
    
}
