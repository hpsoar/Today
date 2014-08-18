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

class CloseIcon : UIView {
    var color: UIColor
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, self.color.CGColor)
        CGContextSetLineWidth(context, 1.0)
        
        var frame = self.frame
        var factor: CGFloat = 0.25
        var x1 = frame.size.width * factor
        var x2 = frame.size.width * (1 - factor)
        var y1 = frame.size.height * factor
        var y2 = frame.size.height * (1 - factor)
        self.drawLine(x1, y1: y1, x2: x2, y2: y2)
        self.drawLine(x1, y1: y2, x2: x2, y2: y1)
        
        CGContextDrawPath(context, kCGPathStroke)
    }
}

class CheckIcon : UIView {
    var color: UIColor
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect)  {
        var context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, self.color.CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        var frame = self.frame
        var factor: CGFloat = 0.25
        var x1: CGFloat = 1.0
        var y1: CGFloat = 7.5
        var x2: CGFloat = 4.0
        var y2: CGFloat = 10.5
        var x3: CGFloat = 11.0
        var y3: CGFloat = 3.0
        var off: CGFloat = 0.25
        self.drawLine(1, y1: 7.5, x2: 5, y2: 11.5)
        self.drawLine(4, y1: 11.5, x2: 12.5, y2: 3)
       // self.drawLine(4, y1: 10, x2: 11.0, y2: 3.0)
        
        CGContextDrawPath(context, kCGPathStroke)
    }
}
