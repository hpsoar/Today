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

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var items: NSMutableArray
    var searchable: Bool
    
    var tableView: UITableView?
    
    var delegate: ItemListViewControllerDelegate?
    
    init(items: NSArray?, searchable: Bool) {
        self.items = NSMutableArray(array: items)
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


    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let identifier = "list_item_cell"
        var cell:UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if !cell {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        cell!.textLabel.text = self.items.objectAtIndex(indexPath!.row) as NSString
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if self.delegate {
            self.delegate!.itemListViewController(self, didSelectItemAtIndex: indexPath.row)
        }
    }
}
