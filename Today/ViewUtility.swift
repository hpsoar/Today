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
        self.layer.drawInContext(UIGraphicsGetCurrentContext())
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
    
    var width: CGFloat {
    get {
        return self.frame.size.width
    }
    set {
        var frame = self.frame
        frame.size.width = newValue
        self.frame = frame
    }
    }
    
    var height: CGFloat {
    get {
        return self.frame.size.height
    }
    set {
        var frame = self.frame
        frame.size.height = newValue
        self.frame = frame
    }
    }
    
    var top: CGFloat {
    get {
        return self.frame.origin.y
    }
    set {
        var frame = self.frame
        frame.origin.y = newValue
        self.frame = frame
    }
    }
    
    var left: CGFloat {
    get {
        return self.frame.origin.x
    }
    set {
        var frame = self.frame
        frame.origin.x = newValue
        self.frame = frame
    }
    }
    
    var bottom: CGFloat {
    get {
        return self.frame.origin.y + self.frame.size.height
    }
    set {
        var frame = self.frame
        frame.origin.y = newValue - frame.size.height
        self.frame = frame
    }
    }
    
    var right: CGFloat {
    get {
        return self.frame.origin.x + self.frame.size.width
    }
    set {
        var frame = self.frame
        frame.origin.x = newValue - frame.size.width
        self.frame = frame
    }
    }    
    
}

typealias UIViewPointer = AutoreleasingUnsafePointer<UIView?>
