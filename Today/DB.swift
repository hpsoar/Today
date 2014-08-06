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

class Item: NSObject, NSCoding {
    init(title: NSString, checked: Bool, allowShare: Bool) {
        self.title = title
        self.checked = checked
        self.allowShare = allowShare
        self.frequency = 0
    }
    
    convenience init() {
        self.init(title: "", checked: false, allowShare: false)
    }
    
    convenience init(title: NSString) {
        self.init(title: title, checked: false, allowShare: false)
    }
    
    init(coder aDecoder: NSCoder!) {
        title = aDecoder.decodeObjectForKey("title") as NSString
        checked = aDecoder.decodeBoolForKey("checked")
        allowShare = aDecoder.decodeBoolForKey("allowShare")
        frequency = aDecoder.decodeInt32ForKey("frequency")
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeBool(checked, forKey: "checked")
        aCoder.encodeBool(allowShare, forKey: "allowShare")
        aCoder.encodeInt32(frequency, forKey: "frequency")
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        assert(object.isKindOfClass(Item) || object.isKindOfClass(NSString), "object of wrong type", file: __FILE__, line: __LINE__)
        
        if object.isKindOfClass(NSString) {
            var title = object as NSString
            return self.title.isEqualToString(title)
        }
        else {
            var item = object as Item
            return item.title.isEqualToString(title)
        }
    }
    
    func updateWithItem(item: Item) {
        title = item.title
        checked = item.checked
        allowShare = item.allowShare
        // 
    }
    
    var title: NSString
    var checked: Bool
    var allowShare: Bool
    var frequency: Int32
}

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
        self.saveItems(items, filename: self.filenameForItemsOfDate(date))
    }
    
    func saveAllItems(items: NSArray?) {
        self.saveItems(items, filename: self.filenameForAllItems())
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
            if items && items!.count > 0 {
                var item:AnyObject = items!.objectAtIndex(0)
                if item.isKindOfClass(Item) {
                    return items!
                }
                else {
                    return self.convertData(items!, filepath: filepath)
                }
            }
        }
        else {
            NSLog("%@", error!)
        }
        return NSArray()
    }
    
    func convertData(items: NSArray, filepath: NSString) -> NSArray {
        var convertedItems = NSMutableArray(capacity: items.count)
        for item : AnyObject in items {
            var title = item as NSString
            convertedItems.addObject(Item(title: title))
        }
        self.saveItems(convertedItems, filepath: filepath)
        
        return convertedItems
    }
    
    func saveItems(items: NSArray?, filename:NSString) {
        if items {
            var filepath: NSString = self.filePath(filename)
            self.saveItems(items!, filepath: filepath)
        }
    }
    
    func saveItems(items: NSArray, filepath: NSString) {
        var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(items)
        var error: NSError?
        if !data.writeToFile(filepath, options: NSDataWritingOptions.DataWritingAtomic, error: &error) {
            NSLog("%@", error!)
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
