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
    init(id: NSUUID, title: String, checked: Bool, allowShare: Bool) {
        self.id = id
        self.title = title
        self.checked = checked
        self.allowShare = allowShare
        self.frequency = 0
        
        super.init()
    }
    
    convenience init(title: String, checked: Bool, allowShare: Bool) {
        self.init(id: NSUUID(), title: title, checked: checked, allowShare: allowShare)
    }
    
    convenience init(title: String) {
        self.init(id: NSUUID(), title: title, checked: false, allowShare: false)
    }
    
    init(coder aDecoder: NSCoder!) {
        id = aDecoder.decodeObjectForKey("id") as NSUUID
        title = aDecoder.decodeObjectForKey("title") as String
        checked = aDecoder.decodeBoolForKey("checked")
        allowShare = aDecoder.decodeBoolForKey("allowShare")
        frequency = aDecoder.decodeInt32ForKey("frequency")
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeBool(checked, forKey: "checked")
        aCoder.encodeBool(allowShare, forKey: "allowShare")
        aCoder.encodeInt32(frequency, forKey: "frequency")
    }
    
    func print() {
        println("\(id), \(title), \(checked), \(allowShare)")
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        assert(object.isKindOfClass(Item) || object.isKindOfClass(NSString), "object of wrong type", file: __FILE__, line: __LINE__)
        
        if object.isKindOfClass(NSString) {
            var title = object as NSString
            return self.title == title
        }
        else {
            var item = object as Item
            return item.title == title
        }
    }
    
    func updateWithItem(item: Item) {
        title = item.title
        checked = item.checked
        allowShare = item.allowShare
        // 
    }
    
    var id: NSUUID
    var title: String
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
    
    var meta: NSDictionary!;
    
    init()  {
        super.init()
        
        var filepath = self.filePath("db.meta")
        var error: NSError?
        var data: NSData? = NSData.dataWithContentsOfFile(filepath, options: NSDataReadingOptions.DataReadingUncached, error: &error)
        if data {
            var meta = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
            if meta {
                self.meta = meta!
            }
        }
        if !self.meta {
            self.meta = [ "version": "1.0" ]
            data = NSKeyedArchiver.archivedDataWithRootObject(self.meta)
            data!.writeToFile(filepath, atomically: true)
        }
    }
    
    // find
    
    func itemWithTitle(title: String) -> Item[] {
        return DB.findItemsWithTitle(title, inItems: self.allItems())
    }
    
    func itemWithTitle(title: String, ofDate date: NSDate) -> Item[] {
        return DB.findItemsWithTitle(title, inItems: self.itemsOfDay(date))
    }
    
    class func findItemsWithTitle(title: String, inItems items: NSArray) -> Item[] {
        var result = Item[]()
        
        for object : AnyObject in items {
            var item = object as Item
            println("\(title), \(item.title)")
            if item.title == title {
                result.append(item)
            }
        }
        return result
    }
    
    func hasDuplicateItem(item: Item) -> Bool {
        return DB.hasDuplicateItem(item, inItems: self.allItems())
    }
    
    func hasDuplicateItem(item: Item, ofDay date: NSDate) -> Bool {
        return DB.hasDuplicateItem(item, inItems: self.itemsOfDay(date))
    }
    
    class func hasDuplicateItem(item: Item, inItems items: NSArray) -> Bool {
        var result = self.findItemsWithTitle(item.title, inItems: items)
        for item2 in result {
            println("\(item2.id), \(item.id)")
            if !item2.id.isEqual(item.id) {
                return true
            }
        }
        return false
    }
    
    // save
    func saveItems(items: NSArray?, ofDay date: NSDate) {
        self.saveItems(items, filename: self.filenameForItemsOfDate(date))
    }
    
    func saveAllItems(items: NSArray?) {
        self.saveItems(items, filename: self.filenameForAllItems())
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

    
    // read
    func allItems() -> Item[] {
        return self.itemsOfFile(self.filenameForAllItems())
    }
    
    func itemsOfDay(date: NSDate) -> Item[] {
        return self.itemsOfFile(self.filenameForItemsOfDate(date))
    }
    
    func itemsOfFile(filename: NSString) -> Item[] {
        var filepath = self.filePath(filename)
        var error: NSError?
        var data: NSData? = NSData.dataWithContentsOfFile(filepath, options: NSDataReadingOptions.DataReadingUncached, error: &error)
        if data {
            var items = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Item[]
            if items {
                return items!
            }
        }
        else {
            NSLog("%@", error!)
        }
        return Item[]()
    }
    
    // read & save helper
    func filenameForAllItems() -> NSString {
        return "all.items"
    }
    
    func filenameForItemsOfDate(date: NSDate) -> NSString {
        var formmater = NSDateFormatter()
        formmater.dateFormat = "YYYY-MM-dd"
        return NSString.localizedStringWithFormat("%@.items", formmater.stringFromDate(date))
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
    
    class func mockItems() -> Item[] {
        var titles = ["hello", "world", "hi", "ha" ]
        var items = Item[]()
        for title in titles {
            items.append(Item(title: title))
        }
        return items
    }
}
