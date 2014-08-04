//
//  ViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemSelectionViewControllerDelegate, TodayItemCellDelegate {
    
    var tableView:UITableView?
    
    var items:NSArray?
    
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
        self.items = DB.instance.itemsOfDay(NSDate())        
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
        let identifier = "cell"
        var cell:TodayItemCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? TodayItemCell
        if !cell {
            cell = TodayItemCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
            cell!.delegate = self
        }
     
        cell!.updateWithItem(self.items!.objectAtIndex(indexPath.row) as Item)
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 66;
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
    
    func showDetailForCell(cell: TodayItemCell)  {
        var indexPath = self.tableView!.indexPathForCell(cell)
        var item = self.items!.objectAtIndex(indexPath.row) as Item
        
        
        
        NSLog("%@", item)
    }
    
    func deleteSelectedForCell(cell: TodayItemCell) {
        
    }
}

