//
//  ViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TodayItemCellDelegate, ItemDetailViewControllerDelegate {
    
    var tableView:UITableView?
    
    var items:NSArray?
    
    var date:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Today"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItem")
        var menuIcon = MenuIcon(frame: CGRectMake(0, 0, 32, 32))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuIcon.snapshot(), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu")
        
        self.loadModel()
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView!.tableFooterView = UIView(frame: CGRectZero);
        self.tableView!.allowsMultipleSelection = true
        self.view.addSubview(self.tableView)
        
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
    }
    
    
    func loadModel() {
        self.date = NSDate()
//        self.items = DB.instance.itemsOfDay(self.date!)
        
        self.items = DB.mockItems()
    }
    
    func addItem() {
    }
    
    func showMenu() {
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items!.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:TodayItemCell? = tableView.dequeueReusableCellWithIdentifier(TodayItemCell.identifier) as? TodayItemCell
        
        if !cell {
            cell = TodayItemCell(style: UITableViewCellStyle.Default, reuseIdentifier: TodayItemCell.identifier)
        }
     
        cell!.delegate = self
        cell!.margin = 5
        cell!.updateWithItem(self.items!.objectAtIndex(indexPath.row) as Item)
        cell!.selected = false
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var item: Item = self.items![indexPath.row] as Item
        
        var height = TodayItemCell.heightForTitle(item.title, withWidth: self.view.frame.size.width) + 10
        return height < 66 ? 66 : height
    }
    
//    func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
//        self.showDetailForCell(tableView.cellForRowAtIndexPath(indexPath) as TodayItemCell)
//        return nil
//    }
    
    func deleteSelectedForCell(cell: TodayItemCell) {
        
    }
    
    
    var detailController: ItemDetailViewController?
    func showDetailForCell(cell: TodayItemCell)  {
        if !self.detailController {
            var indexPath = self.tableView!.indexPathForCell(cell)
            var item = self.items!.objectAtIndex(indexPath.row) as Item
            
            var detailController = ItemDetailViewController(item: item)
            
            detailController.delegate = self
            
            detailController.showFromView(cell)
            
            self.detailController = detailController
            
            NSLog("%@", item)
        }
    }
    
    func itemDetailViewControllerDismissed(controller: ItemDetailViewController) {
        controller.dismiss()
        detailController = nil
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, shouldUpdateItem item: Item, withNewItem newItem: Item?) -> Bool {
        if !newItem || self.items!.containsObject(newItem) {
            return false
        }
        
        if self.date {
            item.updateWithItem(newItem!)
            DB.instance.saveItems(self.items, ofDay: self.date!)
        }
        else {
            DB.instance.saveAllItems(self.items)
        }
        
        self.tableView!.reloadData()
        
        return true
    }
}

