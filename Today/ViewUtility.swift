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
}

typealias UIViewPointer = AutoreleasingUnsafePointer<UIView?>
