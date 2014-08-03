//
//  ViewController.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemSelectionViewControllerDelegate {
    
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
    
    func filePath() -> NSString {
        var fm: NSFileManager = NSFileManager.defaultManager()
        var docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
        
        var ubiq:NSURL? = (UIApplication.sharedApplication().delegate as AppDelegate).ubiq
        if ubiq {
            docsurl = ubiq
        }
        
        NSLog("%@", docsurl)
        
        var filename:NSString = docsurl.path.stringByAppendingPathComponent("test.dat")
        
        NSLog("%@", filename)
       
        return filename
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
        }
     
        cell!.updateWithObject(self.items!.objectAtIndex(indexPath.row) as NSString)
        
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
}

