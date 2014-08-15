//
//  ItemSelectionViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class TouchView : UIView {
    var xSplitPosition:CGFloat = 0.0
    var xSplitWidth:CGFloat = 0.0
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        if (point.x > xSplitPosition - xSplitWidth) && (point.x < xSplitPosition + xSplitWidth) {
            return self
        }
        else {
            return super.hitTest(point, withEvent: event)
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)  {
        
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)  {
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)  {
        
    }
}

protocol ItemSelectionViewControllerDelegate {
    func itemSelectionViewController(controller:ItemSelectionViewController, didSelectItems items:NSArray?)
}

class ItemSelectionViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, TodayItemCellDelegate {
    var delegate: ItemSelectionViewControllerDelegate?
    
    var touchView: TouchView?
    
    // right view, unselected items
    var itemAddingView: UIView?
    var rightTableView: UITableView?
    
    // left view, selected items
    var leftTableView: UITableView?
    
    var allItems: NSMutableArray?
    
    var changedItems: NSMutableArray?
    
    var selectedItems: NSMutableArray?
    
    var unselectedItems: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        // model
        
        self.loadModel()
        
        // navi
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        
        self.touchView = TouchView(frame: self.view.bounds)
        self.view.addSubview(self.touchView)
        
        // left
        var frame = CGRectInset(self.view.bounds, 0, 64)
        frame.size.width /= 2
        self.leftTableView = UITableView(frame: frame)

        var titleLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width, 44))
        titleLabel.text = "Selected for today";
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.greenColor()
        
        self.leftTableView!.tableHeaderView = titleLabel
        
        self.touchView!.addSubview(self.leftTableView)
        
        // right
        frame.origin.x = frame.size.width
        self.rightTableView = UITableView(frame: frame)
        var rightHeaderView = UIView(frame: CGRectMake(0, 0, frame.size.width, 44))
        
        var textField = UITextField(frame: CGRectInset(self.itemAddingView!.bounds, 5, 5))
        textField.placeholder = "New Item"
        textField.clearButtonMode = .WhileEditing
        textField.delegate = self
        rightHeaderView.addSubview(textField)
        
        self.rightTableView!.tableHeaderView = rightHeaderView
        
        self.touchView!.addSubview(self.rightTableView)
        
        self.touchView!.xSplitPosition = frame.size.width
        self.touchView!.xSplitWidth = 10
        
        self.changedItems = NSMutableArray()
        
        // 
        
        self.leftTableView!.delegate = self
        self.leftTableView!.dataSource = self
        
        self.rightTableView!.delegate = self
        self.rightTableView!.dataSource = self
    }
    
    func loadModel() {
        self.allItems = NSMutableArray(array: DB.instance.allItems())
        self.selectedItems = NSMutableArray(array: DB.instance.itemsOfDay(NSDate()))
    }
    
    func done() {
        if changedItems!.count > 0 {
            changedItems!.removeAllObjects()
            
            delegate?.itemSelectionViewController(self, didSelectItems:nil)
        }
        else {
            delegate?.itemSelectionViewController(self, didSelectItems: nil)
        }
    }
    
    
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
//        if string.compare("\n") == 0 {
//            if !textField.text.isEmpty {
//                NSLog("%@", textField.text)
//                var title = textField.text as NSString
//                var item = Item(title: title)
//                if !self.allItems!.containsObject(item) {
//                    self.unselectedItemsController!.addItem(item)
//                    self.allItems!.addObject(item)
//                    DB.instance.saveAllItems(self.allItems)
//                    textField.text = ""
//                    textField.resignFirstResponder()
//                }
//            }
//            return false
//        }
        return true
    }
    
    func itemListViewController(controller: ItemListViewController, didSelectItemAtIndex index: NSInteger)  {
        var item:AnyObject! = controller.itemAtIndex(index)
        
//        if changedItems!.containsObject(item) {
//            changedItems!.removeObject(item)
//        }
//        else {
//            changedItems!.addObject(item)
//        }
//        
//        controller.removeItem(item)
//        if controller == self.unselectedItemsController {
//            self.selectedItemsController!.addItem(item)
//        }
//        else if controller == self.selectedItemsController {
//            self.unselectedItemsController!.addItem(item)
//        }
    }
    
    // tableview delegate / datasource
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTableView {
            return DB.instance.itemsOfDay(NSDate()).count
        }
        else {
            
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var item: Item = self.items[indexPath.row] as Item
        
        // 5 pixels margin
        var height = TodayItemCell.heightForTitle(item.title, withWidth: self.view.frame.size.width - 10) + 10
        return height
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        var cell:TodayItemCell? = tableView?.dequeueReusableCellWithIdentifier(TodayItemCell.identifier) as? TodayItemCell
        if !cell {
            cell = TodayItemCell(style: .Default, reuseIdentifier: TodayItemCell.identifier)
        }
        var item = self.items.objectAtIndex(indexPath!.row) as Item
        cell!.margin = 5
        cell!.delegate = self
        cell!.updateWithItem(item)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if self.delegate {
            self.delegate!.itemListViewController(self, didSelectItemAtIndex: indexPath.row)
        }
    }
}
