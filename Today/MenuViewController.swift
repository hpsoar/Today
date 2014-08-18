//
//  MenuViewController.swift
//  Today
//
//  Created by HuangPeng on 8/18/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit
import QuartzCore

class MenuViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.color(0x5856d6)
        
        var closeIcon = CloseIcon(frame: CGRectMake(13, 26, 32, 32), color: UIColor.whiteColor())
        var closeBtn = UIButton(frame: CGRectMake(7, 0, 44, 44))
        closeBtn.setImage(closeIcon.snapshot(), forState: UIControlState.Normal)
        closeBtn.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        self.closeBtn = closeBtn
        self.view.addSubview(closeBtn)
    }
    
    var window: UIWindow?
    var anchorView: UIView?
    var closeBtn: UIButton!
    var showed = false
    func showFromView(view: UIView) {
        if !showed {
            if !window {
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
            }
            
            if window {
                self.anchorView = view
                self.window!.addSubview(self.view)
                self.show(true, fromView: view)
            }
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
            
            var closeBtnAni = CAKeyframeAnimation(keyPath: "position")
            closeBtnAni.duration = duration
            
            var alpahAni = CAKeyframeAnimation(keyPath: "opacity")
            alpahAni.duration = duration
            
            var frame = window!.convertRect(view.frame, fromView: view.superview)
            var size0 = frame.size
            var position0 = CGPointMake(frame.origin.x + 0.5 * size0.width, frame.origin.y + 0.5 * size0.height)
            
            var size2 = window!.bounds.size
            var position2 = CGPointMake(0.5 * size2.width, 0.5 * size2.height)
            
            var closeBtn0 = CGPointMake(0.5 * size0.width, 0.5 * size0.height)
            var closeBtn2 = position0
            
            if show {
                var arr = [ position0, position2 ]
                pAni.values = [ NSValue(CGPoint: position0), NSValue(CGPoint: position2) ]
                hAni.values = [ NSValue(CGSize: size0), NSValue(CGSize: size2) ]
                alpahAni.values = [ 0, 1 ]
                
                closeBtnAni.values = [ NSValue(CGPoint: closeBtn0), NSValue(CGPoint: closeBtn2) ]
                
                self.view.layer.position = position2
                self.view.layer.bounds = window!.bounds
                self.closeBtn.layer.opacity = 1
                self.closeBtn.layer.position = closeBtn2
            }
            else {
                pAni.values = [ NSValue(CGPoint: position2), NSValue(CGPoint: position0) ]
                hAni.values = [ NSValue(CGSize: size2), NSValue(CGSize: size0) ]
                closeBtnAni.values = [ NSValue(CGPoint: closeBtn2), NSValue(CGPoint: closeBtn0) ]
                alpahAni.values = [ 1, 0 ]
                
                self.view.layer.position = position0
                self.view.frame = frame
                self.closeBtn.layer.opacity = 0
                self.closeBtn.layer.position = closeBtn0
            }
            
            pAni.delegate = self
            
            self.view.layer.addAnimation(pAni, forKey: nil)
            self.view.layer.addAnimation(hAni, forKey: nil)
            self.closeBtn.layer.addAnimation(alpahAni, forKey: nil)
            self.closeBtn.layer.addAnimation(closeBtnAni, forKey: nil)
        }
    }
    
    func cancel() {
        self.dismiss()
    }
    
    func dismiss() {
        if self.anchorView {
            self.show(false, fromView: self.anchorView!)
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)  {
        if showed {
            for v : AnyObject in self.window!.subviews {
                v.removeFromSuperview()
            }
            self.anchorView = nil
            
            self.window!.hidden = true
            self.window = nil
            showed = false
        }
        else {
            showed = true
        }
    }
}
