//
//  ItemListViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/3/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

protocol ItemListViewControllerDelegate {
    func itemListViewController(controller:ItemListViewController, didSelectItemAtIndex index:NSInteger)
}

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TodayItemCellDelegate, ItemDetailViewControllerDelegate {
    var items: NSMutableArray
    var date: NSDate?
    var searchable: Bool
    
    var tableView: UITableView?
    
    var delegate: ItemListViewControllerDelegate?
    
    init(items: NSArray?, date: NSDate?, searchable: Bool) {
        self.items = NSMutableArray(array: items)
        self.date = date
        self.searchable = searchable
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.tableView!.tableFooterView = UIView(frame:CGRectZero)
        self.tableView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView!.tableFooterView = UIView(frame: CGRectZero);
        
        self.view.addSubview(self.tableView)
    }
    
    func addItem(item:AnyObject) -> Bool {
        if !self.items.containsObject(item) {
            self.items.addObject(item)
            self.tableView!.reloadData()
            return true
        }
        return false
    }
    
    func removeItem(item:AnyObject) {
        var oldCount = self.items.count
        self.items.removeObject(item)
        if self.items.count != oldCount {
            self.tableView!.reloadData()
        }
    }
    
    func itemAtIndex(index: NSInteger) -> AnyObject? {
        return self.items.objectAtIndex(index)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
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
    
    func deleteSelectedForCell(cell: TodayItemCell) {
        
    }
    
    func itemDetailViewControllerDismissed(controller: ItemDetailViewController)  {
        detailController = nil
    }
    
    var detailController: ItemDetailViewController?
    func showDetailForCell(cell: TodayItemCell)  {
        if !detailController {
            var indexPath = self.tableView!.indexPathForCell(cell)
            var item = self.items.objectAtIndex(indexPath.row) as Item
            
            detailController = ItemDetailViewController(item: item)
            
            detailController!.delegate = self
            
            detailController!.showFromView(cell)
            
            NSLog("%@", item)
        }
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, finishedEditingItem item: Item?, withNewItem newItem: Item) -> Bool {
        if !item {
            return false
        }
        
        if self.date {
            // if the item belongs to today
            // 1. check duplication in today's items
            // 2. check duplication in all items
            if !DB.instance.hasDuplicateItem(newItem, ofDay: self.date!) && !DB.instance.hasDuplicateItem(newItem) {
                item!.updateWithItem(newItem)
                DB.instance.saveItems(self.items, ofDay: self.date!)
            }
        }
        else {
            // if item belongs to all item collection
            // 1. check duplication if all item collection
            if !DB.instance.hasDuplicateItem(newItem) {
                item!.updateWithItem(newItem)
                DB.instance.saveAllItems(self.items)
            }
        }
        
        self.tableView!.reloadData()
        
        return true
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, willDeleteItem item: Item) -> Bool  {
        return true
    }
}
