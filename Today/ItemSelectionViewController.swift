//
//  ItemSelectionViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

protocol ItemSelectionViewControllerDelegate {
    func itemSelectionViewController(controller:ItemSelectionViewController, didSelectItems items:NSArray?)
}

class ItemSelectionViewController: UIViewController, UITextFieldDelegate, ItemListViewControllerDelegate {
    var delegate: ItemSelectionViewControllerDelegate?
    var allItemsController: ItemListViewController?
    var selectedItemsController: ItemListViewController?
    
    var itemAddingView: UIView?
    var rightView: UIView?
    var leftView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        // navi
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        
        // left
        var frame = CGRectInset(self.view.bounds, 0, 64)
        frame.size.width /= 2
        
        self.setupLeftViewWithFrame(frame)
        
        // right
        frame.origin.x = frame.size.width
        self.setupRightViewWithFrame(frame)
    }
    
    func done() {
        delegate?.itemSelectionViewController(self, didSelectItems:self.selectedItemsController!.items)
    }
    
    func cancel() {
        delegate?.itemSelectionViewController(self, didSelectItems:nil)
    }
    
    func setupLeftViewWithFrame(frame: CGRect) {
        self.leftView = UIView(frame: frame)
        self.view.addSubview(self.leftView)
        
        self.selectedItemsController = ItemListViewController(items: DB.instance.itemsOfDay(NSDate()), searchable: false)
        self.selectedItemsController!.delegate = self
        
        self.leftView!.addSubview(self.selectedItemsController!.view)
    }
    
    func setupRightViewWithFrame(frame: CGRect) {
        self.rightView = UIView(frame: frame)
        self.rightView!.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.rightView!.layer.shadowRadius = 5
        self.rightView!.layer.shadowOpacity = 0.8
        self.rightView!.layer.shadowOffset = CGSizeMake(-2, 2)
        self.rightView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.rightView)
        
        self.itemAddingView = UIView(frame: CGRectMake(0, 0, frame.size.width, 44))
        self.rightView!.addSubview(self.itemAddingView)
        
        var textField = UITextField(frame: CGRectInset(self.itemAddingView!.bounds, 5, 5))
        textField.placeholder = "New Item"
        textField.clearButtonMode = .WhileEditing
        textField.delegate = self
        self.itemAddingView!.addSubview(textField)
        
        var allItems = NSMutableArray(array: DB.instance.allItems())
        var selectedItems = DB.instance.itemsOfDay(NSDate())
        for item in selectedItems {
            allItems.removeObject(item)
        }
        self.allItemsController = ItemListViewController(items: allItems, searchable: true)
        self.allItemsController!.delegate = self
        
        self.allItemsController!.view.frame = CGRectMake(0, 44, frame.size.width, frame.size.height - 44)
        self.rightView!.addSubview(self.allItemsController!.view)
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string.compare("\n") == 0 {
            if !textField.text.isEmpty {
                NSLog("%@", textField.text)
                if (self.allItemsController!.addItem(textField.text as NSString)) {
                    textField.text = ""
                    DB.instance.saveItems(self.allItemsController!.items)
                }
            }
            return false
        }
        return true
    }
    
    func itemListViewController(controller: ItemListViewController, didSelectItemAtIndex index: NSInteger)  {
        var item = controller.itemAtIndex(index) as NSString
        controller.removeItem(item)
        if controller == self.allItemsController {
            self.selectedItemsController!.addItem(item)
        }
        else if controller == self.selectedItemsController {
            self.allItemsController!.addItem(item)
        }
    }
}
