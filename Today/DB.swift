//
//  DB.swift
//  Today
//
//  Created by Aldrich Huang on 8/3/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

//class Singleton<T> {
//    class var shared: T {
//    dispatch_once(&Inner.token) {
//        Inner.instance = T()
//        }
//        return Inner.instance!
//    }
//    struct Inner {
//        static var instance: T?
//        static var token: dispatch_once_t = 0
//    }
//}

class DB: NSObject {
    class var instance: DB {
    dispatch_once(&Inner.token) {
            Inner.instance = DB()
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: DB?
        static var token: dispatch_once_t = 0
    }
    
    func allItems() -> NSArray {
        return self.itemsOfFile(self.filenameForAllItems())
    }
    
    func itemsOfDay(date: NSDate) -> NSArray {
        return self.itemsOfFile(self.filenameForItemsOfDate(date))
    }
    
    func saveItems(items: NSArray?, ofDay date: NSDate) {
        self.saveItems(items, toFile: self.filenameForItemsOfDate(date))
    }
    
    func saveItems(items: NSArray?) {
        self.saveItems(items, toFile: self.filenameForAllItems())
    }
    
    func filenameForAllItems() -> NSString {
        return "all.items"
    }
    
    func filenameForItemsOfDate(date: NSDate) -> NSString {
        var formmater = NSDateFormatter()
        formmater.dateFormat = "YYYY-MM-dd"
        return NSString.localizedStringWithFormat("%@.items", formmater.stringFromDate(date))
    }
    
    func itemsOfFile(filename: NSString) -> NSArray {
        var filepath = self.filePath(filename)
        var error: NSError?
        var data: NSData? = NSData.dataWithContentsOfFile(filepath, options: NSDataReadingOptions.DataReadingUncached, error: &error)
        if data {
            var items = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSArray
            if items {
                return items!
            }
        }
        else {
            NSLog("%@", error!)
        }
        return NSArray()
    }
    
    func saveItems(items: NSArray?, toFile filename:NSString) {
        if items {
            var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(items)
            var filepath: NSString = self.filePath(filename)
            var error: NSError?
            if !data.writeToFile(filepath, options: NSDataWritingOptions.DataWritingAtomic, error: &error) {
                NSLog("%@", error!)
            }
        }
    }
    
    func filePath(filename: NSString) -> NSString {
        var fm: NSFileManager = NSFileManager.defaultManager()
        var docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
        
        var ubiq:NSURL? = (UIApplication.sharedApplication().delegate as AppDelegate).ubiq
        if ubiq {
            docsurl = ubiq
        }
        
        NSLog("%@", docsurl)
        
        var tmp = docsurl.path.stringByAppendingPathComponent(filename)
        
        NSLog("%@", tmp)
        
        return tmp
    }
}
