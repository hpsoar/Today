//
//  Icon.swift
//  Today
//
//  Created by HuangPeng on 8/16/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class MenuIcon : UIView {
    
    init(frame: CGRect)  {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
 
    override func drawRect(rect: CGRect)  {
        var context = UIGraphicsGetCurrentContext();
        
        
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        let x1:CGFloat = 6.0
        let x2:CGFloat = 26.0
        
        self.drawLine(x1, y1: 10.0, x2: x2, y2: 10.0)
        self.drawLine(x1, y1: 16.0, x2: x2, y2: 16.0)
        self.drawLine(x1, y1: 22.0, x2: x2, y2: 22.0)
        
        CGContextDrawPath(context, kCGPathStroke)
    }
    
    func drawLine(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        var context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, x1, y1)
        CGContextAddLineToPoint(context, x2, y2)
    }
}

class RoundMarkIcon : UIView {
    var state: Bool = false
    var selected: Bool {
    get {
        return self.state
    }
    set {
        self.state = newValue
        if newValue {
            self.backgroundColor = UIColor.orangeColor()
        }
        else {
            self.backgroundColor = UIColor.clearColor()
        }
    }
    }
    
    init(frame: CGRect)  {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = frame.size.width / 2
        self.clipsToBounds = true
    }
}
