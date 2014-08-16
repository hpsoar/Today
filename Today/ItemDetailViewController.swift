//
//  ItemDetailViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/3/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit
import QuartzCore

class Line: UIView {
    init(length: CGFloat, width: CGFloat, color: UIColor) {
        super.init(frame: CGRectMake(0, 0, length, width))
        self.backgroundColor = color
    }
}

extension UIView {
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

class BorderedView: UIView {
    var leftBorder: UIView?
    var rightBorder: UIView?
    var topBorder: UIView?
    var bottomBorder: UIView?
    
    func border(direction: NSInteger) -> UIView! {
        switch direction {
        case 1:
            return self.createBorder(&self.leftBorder, x: 0, y: 0, width: 1, height: self.height, direction: direction)
        case 2:
            return self.createBorder(&self.topBorder, x: 0, y: 0, width: self.width, height: 1, direction: direction)
        case 3:
            return self.createBorder(&self.rightBorder, x: self.width - 1, y: 0, width: 1, height: self.height, direction: direction)
        default:
            return self.createBorder(&self.bottomBorder, x: 0, y: self.height - 1, width: self.width, height: 1, direction: direction)
        }
    }
    
    func createBorder(border: UIViewPointer, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, direction: NSInteger) -> UIView! {
        if !border.memory {
            var view = UIView(x: x, y: y, width: width, height: height)
            switch direction {
            case 1:
                view.autoresizingMask = UIViewAutoresizing.FlexibleHeight
            case 2:
                view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            case 3:
                view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
            default:
                view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
            }
            self.addSubview(view)
            border.memory = view
        }
        return border.memory
    }
}

class SwitchView: BorderedView {
    var titleLabel: UILabel
    var varSwitch: UISwitch
    
    var on: Bool {
        get {
            return varSwitch.on
        }
    }
    
    init(frame: CGRect, title: NSString, value: Bool)  {
        self.titleLabel = UILabel(frame: frame)
        self.varSwitch = UISwitch(frame: frame)
        
        self.titleLabel.text = title
        self.varSwitch.on = value
        
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.varSwitch)
        
        self.titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.varSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var views = [ "label": self.titleLabel, "switch": self.varSwitch]

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: nil, metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label]-[switch]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
    }
    
    func setTextColor(color: UIColor) {
        self.titleLabel.textColor = color
        self.border(2).backgroundColor = UIColor.whiteColor()
    }
}

protocol ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDismissed(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, finishedEditingItem item: Item?, withNewItem newItem: Item) -> Bool
}

class ItemDetailViewController: UIViewController, UITextFieldDelegate {
    var item: Item?
    
    var container: UIView!
    var titleField: UITextField!
    var allowShareSwitch: SwitchView!
    var checkedSwitch: SwitchView!
    var saveBtn: UIButton!
    var cancelBtn: UIButton!
    var buttonContainer: BorderedView!
    var delegate: ItemDetailViewControllerDelegate?
    
    init(item: Item?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        self.view.clipsToBounds = true
        
        var width: CGFloat = 240
        var xOffset: CGFloat = (320 - width) / 2
        var height: CGFloat = 50
        
        self.container = UIView(x: 0, y: 13, width: 320, height: height * 4)
        self.view.addSubview(self.container)
        
        self.titleField = UITextField(frame: CGRectMake(xOffset, 0, width, 40))
        if self.item {
            self.titleField.text = self.item!.title
        }
        else {
            self.titleField.placeholder = "New Item"
        }
        self.titleField.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.titleField.textAlignment = NSTextAlignment.Center
        self.titleField.returnKeyType = UIReturnKeyType.Done
        self.titleField.delegate = self
        self.titleField.textColor = UIColor.whiteColor()
        self.container.addSubview(self.titleField)
        
        var allowShare = false
        var checked = false
        if self.item {
            allowShare = self.item!.allowShare
            checked = self.item!.checked
        }
        
        self.allowShareSwitch = SwitchView(frame: CGRectMake(xOffset, self.titleField.bottom, width, height), title: "Allow Share", value: allowShare)
        self.allowShareSwitch!.setTextColor(UIColor.whiteColor())
        self.container.addSubview(self.allowShareSwitch)
        
        // TODO: only show this for today's item
        self.checkedSwitch = SwitchView(frame: CGRectMake(xOffset, self.allowShareSwitch.bottom, width, height), title: "Checked", value: checked)
        self.checkedSwitch!.setTextColor(UIColor.whiteColor())
        self.container.addSubview(self.checkedSwitch)
        
        self.buttonContainer = BorderedView(frame: CGRectMake(xOffset, self.checkedSwitch.bottom, width, height))
        self.buttonContainer.border(2).backgroundColor = UIColor.whiteColor()
        self.container.addSubview(self.buttonContainer)
        
        self.saveBtn = UIButton(frame: CGRectZero)
        self.saveBtn!.backgroundColor = UIColor.greenColor()
        self.saveBtn!.layer.cornerRadius = 5
        self.saveBtn!.setTitle("Save", forState: UIControlState.Normal)
        self.saveBtn!.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        self.saveBtn!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.buttonContainer!.addSubview(self.saveBtn)
        
        self.cancelBtn = UIButton(frame: CGRectZero)
        self.cancelBtn!.backgroundColor = UIColor.lightGrayColor()
        self.cancelBtn!.layer.cornerRadius = 5
        self.cancelBtn!.setTitle("Cancel", forState: UIControlState.Normal)
        self.cancelBtn!.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        self.cancelBtn!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.buttonContainer!.addSubview(self.cancelBtn)
        
        var views = [ "saveBtn": self.saveBtn!, "superview": self.buttonContainer!, "cancelBtn": self.cancelBtn! ]
        
        self.buttonContainer!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[saveBtn(70)]-[cancelBtn(70)]-30-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
       self.buttonContainer!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[saveBtn(60)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
    }
    
    var window: UIWindow?
    var anchorView: UIView?
    func showFromView(view: UIView) {
        if !window {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
        }
        
        if window {
            self.anchorView = view
            self.window!.addSubview(self.view)
            self.show(true, fromView: view)
        }
    }
    
    func show(show: Bool, fromView view: UIView) {
        if window {
            window!.hidden = false
            
            var duration = 0.3
            var pAni = CAKeyframeAnimation(keyPath: "position")
            pAni.duration = duration
            
            var hAni = CAKeyframeAnimation(keyPath: "bounds.size")
            hAni.duration = duration
            
            var ani2 = CAKeyframeAnimation(keyPath: "position.y")
            ani2.duration = duration
    
            var alpahAni = CAKeyframeAnimation(keyPath: "opacity")
            alpahAni.duration = duration
            
            var frame = window!.convertRect(view.frame, fromView: view.superview)
            var size0 = frame.size
            var position0 = CGPointMake(frame.origin.x + 0.5 * size0.width, frame.origin.y + 0.5 * size0.height)
            
            var size2 = window!.bounds.size
            var position2 = CGPointMake(0.5 * size2.width, 0.5 * size2.height)
            
            var positionY2:CGFloat = 13.0 + 0.5 * self.container.height
            var endY2:CGFloat = 64 + 0.5 * self.container.height
            var middleY2:CGFloat = (positionY2 + endY2) * 0.5
            
            if show {
                var arr = [ position0, position2 ]
                pAni.values = [ NSValue(CGPoint: position0), NSValue(CGPoint: position2) ]
                hAni.values = [ NSValue(CGSize: size0), NSValue(CGSize: size2) ]
                
                ani2.values = [positionY2,  endY2]
                alpahAni.values = [ 0, 1 ]
                
                self.view.layer.position = position2
                self.view.layer.bounds = window!.bounds
                self.container.layer.position.y = endY2
                self.container.layer.opacity = 1
            }
            else {
                pAni.values = [ NSValue(CGPoint: position2), NSValue(CGPoint: position0) ]
                hAni.values = [ NSValue(CGSize: size2), NSValue(CGSize: size0) ]
                
                ani2.values = [endY2, positionY2]
                alpahAni.values = [ 1, 0 ]
                pAni.delegate = self
                
                self.view.layer.position = position0
                self.view.frame = frame
                self.container.layer.position.y = positionY2
                self.container.layer.opacity = 0
            }

            self.view.layer.addAnimation(pAni, forKey: nil)
            self.view.layer.addAnimation(hAni, forKey: nil)
            
            self.container.layer.addAnimation(ani2, forKey: nil)
            self.container.layer.addAnimation(alpahAni, forKey: nil)
        }
    }
    
    func dismiss() {
        if self.anchorView {
            self.show(false, fromView: self.anchorView!)
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)  {
        for v : AnyObject in self.window!.subviews {
            v.removeFromSuperview()
        }
        self.anchorView = nil
        
        self.window!.hidden = true
        self.window = nil
        
        if delegate {
            delegate!.itemDetailViewControllerDismissed(self)
        }
    }
    
    func save() {
        if delegate {
            if !titleField!.text.isEmpty {
                var item2 = Item(title: titleField!.text, checked: checkedSwitch!.on, allowShare: allowShareSwitch!.on)
                if delegate!.itemDetailViewController(self, finishedEditingItem:self.item, withNewItem: item2) {
                    self.dismiss()
                }
            }
        }
    }
    
    func cancel() {
        self.dismiss()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        return true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        return true
    }
}
