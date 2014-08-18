//
//  ViewUtility.swift
//  Today
//
//  Created by HuangPeng on 8/16/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

extension UIView  {
    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRectMake(x, y, width, height))
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
    
    func drawLine(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        var context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, x1, y1)
        CGContextAddLineToPoint(context, x2, y2)
    }
}

typealias UIViewPointer = AutoreleasingUnsafePointer<UIView?>

extension UIColor {
    class func color(hexColor: NSInteger) -> UIColor! {
        var r = CGFloat((hexColor >> 16) & 0xFF) / 255.5
        var g = CGFloat((hexColor >> 8) & 0xFF) / 255.5
        var b = CGFloat(hexColor & 0xFF) / 255.5
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
