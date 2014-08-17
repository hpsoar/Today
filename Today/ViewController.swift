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
    
    var items = Item[]()
    
    var date:NSDate?
    
    var detailController: ItemDetailViewController?
    
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
        self.items = DB.instance.itemsOfDay(self.date!)        
    }
    
    func addItem() {
        if !self.detailController {
            var detailController = ItemDetailViewController(item: nil)
            
            detailController.delegate = self
            
            var view:UIView? = self.navigationItem.rightBarButtonItem.valueForKey("view") as? UIView
            
            if (view) {
                detailController.showFromView(view!)
            }
            
            self.detailController = detailController
        }
    }
    
    func showMenu() {
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:TodayItemCell? = tableView.dequeueReusableCellWithIdentifier(TodayItemCell.identifier) as? TodayItemCell
        
        if !cell {
            cell = TodayItemCell(style: UITableViewCellStyle.Default, reuseIdentifier: TodayItemCell.identifier)
        }
     
        cell!.delegate = self
        cell!.margin = 5
        cell!.updateWithItem(self.items[indexPath.row])
        cell!.selected = false
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var item: Item = self.items[indexPath.row] as Item
        
        var height = TodayItemCell.heightForTitle(item.title, withWidth: self.view.frame.size.width) + 10
        return height < 66 ? 66 : height
    }
    
//    func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
//        self.showDetailForCell(tableView.cellForRowAtIndexPath(indexPath) as TodayItemCell)
//        return nil
//    }
    
    func deleteSelectedForCell(cell: TodayItemCell) {
        
    }
    
    func showDetailForCell(cell: TodayItemCell)  {
        if !self.detailController {
            var indexPath = self.tableView!.indexPathForCell(cell)
            var item = self.items[indexPath.row]
            
            var detailController = ItemDetailViewController(item: item)
            
            detailController.delegate = self
                        
            detailController.showFromView(cell)
            
            self.detailController = detailController
            
            NSLog("%@", item)
        }
    }
    
    func itemDetailViewControllerDismissed(controller: ItemDetailViewController) {
        detailController = nil
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, finishedEditingItem item: Item?, withNewItem newItem: Item) -> Bool  {
        assert(self.date, "date can't be nil")
        assert(self.tableView, "tableView can't be nil")
        
        println(newItem.title)
        if DB.instance.hasDuplicateItem(newItem, ofDay: self.date!) {
            return false
        }
        
        if item {
            item!.updateWithItem(newItem)
        }
        else {
            self.items.append(newItem)
        }
        
        DB.instance.saveItems(self.items, ofDay: self.date!)
        self.tableView!.reloadData()
        return true
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, willDeleteItem item: Item) -> Bool  {
        assert(self.date, "date can't be nil")
        assert(self.tableView, "tableView can't be nil")

        var tmp = self.items.filter({ $0 != item })
        var i = self.items.count
        var j = tmp.count
        println("\(i), \(j)")
        println("\(tmp), \(self.items)")
        
        self.items = tmp
        DB.instance.saveItems(self.items, ofDay: self.date!)
        self.tableView!.reloadData()
        
        return true
    }
}

