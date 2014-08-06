//
//  ViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemSelectionViewControllerDelegate, TodayItemCellDelegate, ItemDetailViewControllerDelegate {
    
    var tableView:UITableView?
    
    var items:NSArray?
    
    var date:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Besides Work"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItem")
        
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
        self.items = DB.instance.itemsOfDay(self.date!)
    }
    
    func addItem() {
        var controller = ItemSelectionViewController()
        controller.delegate = self
        
        self.presentModalViewController(UINavigationController(rootViewController: controller), animated: true)
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
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var item: Item = self.items![indexPath.row] as Item
        
        var height = TodayItemCell.heightForTitle(item.title, withWidth: self.view.frame.size.width) + 10
        return height < 66 ? 66 : height
    }

    func itemSelectionViewController(controller: ItemSelectionViewController, didSelectItems items: NSArray?)  {
        controller.dismissModalViewControllerAnimated(true)
        
        if items {
            self.items = items
            self.tableView!.reloadData()
            dispatch_async(dispatch_get_global_queue(0, 0), {
                DB.instance.saveItems(self.items, ofDay: NSDate())
            })
        }
    }
    
    func deleteSelectedForCell(cell: TodayItemCell) {
        
    }
    
    var detailController: ItemDetailViewController?
    
    func showDetailForCell(cell: TodayItemCell)  {
        if !detailController {
            var indexPath = self.tableView!.indexPathForCell(cell)
            var item = self.items!.objectAtIndex(indexPath.row) as Item
            
            detailController = ItemDetailViewController(item: item)
            
            detailController!.delegate = self
            
            detailController!.showFromView(cell)
            
            NSLog("%@", item)
        }
    }
    
    func itemDetailViewControllerDismissed(controller: ItemDetailViewController) {
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

