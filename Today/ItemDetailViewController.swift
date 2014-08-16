//
//  ItemDetailViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/3/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class Line: UIView {
    init(length: CGFloat, width: CGFloat, color: UIColor) {
        super.init(frame: CGRectMake(0, 0, length, width))
        self.backgroundColor = color
    }
}

extension UIView {
    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRectMake(x, y, width, height))
    }
    
    var width: CGFloat {
        return CGRectGetWidth(self.frame)
    }
    
    var height: CGFloat {
        return CGRectGetHeight(self.frame)
    }
}

typealias UIViewPointer = AutoreleasingUnsafePointer<UIView?>

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
    func itemDetailViewController(controller: ItemDetailViewController, shouldUpdateItem item:Item, withNewItem newItem: Item?) -> Bool
}

class ItemDetailViewController: UIViewController, UITextFieldDelegate {
    var item: Item
    
    var titleField: UITextField?
    var allowShareSwitch: SwitchView?
    var checkedSwitch: SwitchView?
    var saveBtn: UIButton?
    var cancelBtn: UIButton?
    var buttonContainer: BorderedView?
    var container: UIView?
    var delegate: ItemDetailViewControllerDelegate?
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleField = UITextField(frame: CGRectMake(0, 0, 320, 40))
        self.titleField!.text = item.title
        self.titleField!.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.titleField!.textAlignment = NSTextAlignment.Center
        self.titleField!.returnKeyType = UIReturnKeyType.Done
        self.titleField!.delegate = self
        self.titleField!.textColor = UIColor.whiteColor()
        self.view.addSubview(self.titleField)
        
        self.container = UIView(frame: CGRectZero)
        self.view.addSubview(self.container)
        
        self.allowShareSwitch = SwitchView(frame: CGRectZero, title: "Allow Share", value: self.item.allowShare)
        self.allowShareSwitch!.setTextColor(UIColor.whiteColor())
        self.container!.addSubview(self.allowShareSwitch)
        
        // TODO: only show this for today's item
        self.checkedSwitch = SwitchView(frame: CGRectZero, title: "Checked", value: self.item.checked)
        self.checkedSwitch!.setTextColor(UIColor.whiteColor())
        self.container!.addSubview(self.checkedSwitch)
        
        self.buttonContainer = BorderedView(frame: CGRectZero)
        self.container!.addSubview(self.buttonContainer)
        self.buttonContainer!.border(2).backgroundColor = UIColor.whiteColor()
        
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
        
        self.view.backgroundColor = UIColor.orangeColor()
    }
    
    var window:UIWindow?
    func showFromView(view: UIView) {
        if !window {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
        }
        
        if window {
            window!.hidden = false
            var frame = window!.convertRect(view.frame, fromView: view.superview)
            self.view.frame = frame
            self.titleField!.frame = self.view.bounds
            window!.addSubview(self.view)
            
            self.container!.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                    self.view.frame = CGRectOffset(self.window!.bounds, 0, 20)
                    self.titleField!.frame = CGRectMake(0, 0, 320, 44)
                }, completion: {
                    (finished: Bool) in
                    var width: CGFloat = 240
                    var xOffset: CGFloat = (320 - width) / 2
                    var height: CGFloat = 50
                    self.titleField!.frame = CGRectMake(xOffset, 0, width, height)
                    
                    var top: CGFloat = self.titleField!.frame.origin.y + self.titleField!.frame.size.height
                    
                    self.container!.frame = CGRectMake(xOffset, top, width, height * 3)
                    
                    top = 0
                    self.allowShareSwitch!.frame = CGRectMake(0, top, width, height)
                    top += height
                    self.checkedSwitch!.frame = CGRectMake(0, top, width, height)
                    top += height
                    self.buttonContainer!.frame = CGRectMake(0, top, width, height)
                    
                    UIView.animateWithDuration(0.5, animations: {
                        self.container!.alpha = 1
                        self.titleField!.becomeFirstResponder()
                        })
                })
        }
    }
    
    func dismiss() {
        for v in self.window!.subviews {
            v.removeFromSuperview()
        }
        self.window!.hidden = true
        self.window = nil
    }
    
    func save() {
        if delegate {
            if !titleField!.text.isEmpty {
                var item = Item(title: titleField!.text, checked: checkedSwitch!.on, allowShare: allowShareSwitch!.on)
                if delegate!.itemDetailViewController(self, shouldUpdateItem: self.item, withNewItem: item) {
                    self.window!.hidden = true
                    delegate!.itemDetailViewControllerDismissed(self)
                }
            }
            else {
                self.titleField!.text = self.item.title
            }
        }
    }
    
    func cancel() {
        if delegate {
            delegate!.itemDetailViewControllerDismissed(self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        return true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        return true
    }
}
