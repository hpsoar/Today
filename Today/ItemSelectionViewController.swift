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
    var unselectedItemsController: ItemListViewController?
    var selectedItemsController: ItemListViewController?
    
    var itemAddingView: UIView?
    var rightView: UIView?
    var leftView: UIView?
    
    var allItems: NSMutableArray?
    
    var changedItems: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        // navi
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        
        // left
        var frame = CGRectInset(self.view.bounds, 0, 64)
        frame.size.width /= 2
        
        self.setupLeftViewWithFrame(frame)
        
        // right
        frame.origin.x = frame.size.width
        self.setupRightViewWithFrame(frame)
        
        self.changedItems = NSMutableArray()
    }
    
    func done() {
        if changedItems!.count > 0 {
            changedItems!.removeAllObjects()
            
            delegate?.itemSelectionViewController(self, didSelectItems:self.selectedItemsController!.items)
        }
        else {
            delegate?.itemSelectionViewController(self, didSelectItems: nil)
        }
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
        self.rightView!.layer.shadowRadius = 2
        self.rightView!.layer.shadowOpacity = 0.8
        self.rightView!.layer.shadowOffset = CGSizeMake(-1, 1)
        self.rightView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.rightView)
        
        self.itemAddingView = UIView(frame: CGRectMake(0, 0, frame.size.width, 44))
        self.rightView!.addSubview(self.itemAddingView)
        
        var textField = UITextField(frame: CGRectInset(self.itemAddingView!.bounds, 5, 5))
        textField.placeholder = "New Item"
        textField.clearButtonMode = .WhileEditing
        textField.delegate = self
        self.itemAddingView!.addSubview(textField)
        
        self.allItems = NSMutableArray(array: DB.instance.allItems())
        var selectedItems = DB.instance.itemsOfDay(NSDate())
        var unselectedItems = NSMutableArray(capacity: self.allItems!.count - selectedItems.count)
        for item in self.allItems! {
            if !selectedItems.containsObject(item) {
                unselectedItems.addObject(item)
            }
        }
        self.unselectedItemsController = ItemListViewController(items: unselectedItems, searchable: true)
        self.unselectedItemsController!.delegate = self
        
        self.unselectedItemsController!.view.frame = CGRectMake(0, 44, frame.size.width, frame.size.height - 44)
        self.rightView!.addSubview(self.unselectedItemsController!.view)
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string.compare("\n") == 0 {
            if !textField.text.isEmpty {
                NSLog("%@", textField.text)
                var title = textField.text as NSString
                var item = Item(title: title)
                if !self.allItems!.containsObject(item) {
                    self.unselectedItemsController!.addItem(item)
                    self.allItems!.addObject(item)
                    DB.instance.saveItems(self.allItems)
                    textField.text = ""
                    textField.resignFirstResponder()
                }
            }
            return false
        }
        return true
    }
    
    func itemListViewController(controller: ItemListViewController, didSelectItemAtIndex index: NSInteger)  {
        var item:AnyObject! = controller.itemAtIndex(index)
        
        if changedItems!.containsObject(item) {
            changedItems!.removeObject(item)
        }
        else {
            changedItems!.addObject(item)
        }
        
        controller.removeItem(item)
        if controller == self.unselectedItemsController {
            self.selectedItemsController!.addItem(item)
        }
        else if controller == self.selectedItemsController {
            self.unselectedItemsController!.addItem(item)
        }
    }
}
