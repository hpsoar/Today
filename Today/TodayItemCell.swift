//
//  TodayItemCell.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

protocol TodayItemCellDelegate {
    func showItemDetailForCell(cell: TodayItemCell)
    func deleteItemForCell(cell: TodayItemCell)
}

class TodayItemCell: UITableViewCell {

    var titleLabel: UILabel!
    var deleteBtn: UIButton!
    var container: UIView!
    
    var delegate: TodayItemCellDelegate?
    var margin: CGFloat = 5
    var cellColor: UIColor = UIColor.redColor()
    var cellColorSelected: UIColor = UIColor.greenColor()
    
    class var font: UIFont {
        return UIFont.systemFontOfSize(17)
    }
    
    class var identifier: String {
        return NSStringFromClass(TodayItemCell)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var redView = UIView(frame: CGRectMake(5, 5, 310, 56))
        redView.layer.cornerRadius = 5;
        redView.backgroundColor = UIColor.redColor()
        self.backgroundView = redView;
        
        var greenView = UIView(frame: redView.bounds);
        greenView.layer.cornerRadius = redView.layer.cornerRadius
        greenView.backgroundColor = UIColor.greenColor()
        self.selectedBackgroundView = greenView
        
        container = UIView(frame: redView.frame)
        container.clipsToBounds = true
        self.contentView.addSubview(container)
        
        titleLabel = UILabel(frame: CGRectInset(container.bounds, 2, 2))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        
        deleteBtn = UIButton(frame: CGRectMake(310, 10, 70, 36))
        deleteBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.backgroundColor = UIColor.orangeColor()
        var btnBk = deleteBtn.snapshot()
        deleteBtn.setBackgroundImage(btnBk, forState: UIControlState.Normal)
        deleteBtn.setTitle("Delete", forState: UIControlState.Normal)
        deleteBtn.addTarget(self, action: "delete", forControlEvents: UIControlEvents.TouchUpInside)
        
        container.addSubview(deleteBtn)
        
        container.addSubview(titleLabel)
        
        self.userInteractionEnabled = true
        
        var swipe = UISwipeGestureRecognizer(target: self, action: "showDeleteBtn")
        swipe.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipe)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "showDetail")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView.frame = CGRectInset(self.bounds, 5, 5)
        self.selectedBackgroundView.frame = self.backgroundView.frame;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func updateWithItem(item:Item) {
        item.print()
        
        titleLabel.text = item.title
        self.selected = item.checked
        
        if self.onDeleting {
            self.showDeleteBtn(false)
        }
    }
    
    func showDetail() {
        if self.onDeleting {
            self.showDeleteBtn(false)
        }
        else {
            self.delegate?.showItemDetailForCell(self)
        }
    }
    
    var onDeleting = false
    
    func showDeleteBtn() {
        self.showDeleteBtn(true)
    }
    
    func showDeleteBtn(show: Bool) {
        self.onDeleting = show
        
        var offset: CGFloat = self.deleteBtn.frame.size.width + 10
        self.deleteBtn.alpha = 1
        if show {
            offset *= -1
            self.deleteBtn.alpha = 0
        }
        
        UIView.animateWithDuration(0.3, animations:
            {
                var frame = self.titleLabel.frame
                frame.origin.x += offset
                self.titleLabel.frame = frame
                
                frame = self.deleteBtn.frame
                frame.origin.x += offset
                self.deleteBtn.frame = frame
                
                self.deleteBtn.alpha = show ? 1 : 0
            }, completion: {
                finished in
                
            })
    }
    
    func delete() {
        self.delegate?.deleteItemForCell(self)
    }
    
    class func heightForTitle(title:NSString, withWidth width: CGFloat) -> CGFloat {
        return title.sizeWithFont(self.font, forWidth: width, lineBreakMode: NSLineBreakMode.ByCharWrapping).height
    }
}
