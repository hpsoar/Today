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

class ItemTitleView: UIView {
    var titleLabel: UILabel!
    var checkIcon: CheckIcon!
    var title: String {
    get {
       return titleLabel.text
    }
    set {
        titleLabel.text = newValue
    }
    }
    var selected: Bool {
    get {
        return !checkIcon.hidden
    }
    set {
        checkIcon.hidden = !newValue
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        
        titleLabel = UILabel(frame: self.bounds)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.contentMode = UIViewContentMode.Center
        titleLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel)
        
        checkIcon = CheckIcon(frame: CGRectMake(0, 0, 14, 14), color: UIColor.color(0x007aff))
        self.addSubview(checkIcon)
        
        checkIcon.center = CGPointMake(self.frame.width - 15, self.frame.height / 2)
        titleLabel.frame = CGRectInset(self.bounds, self.frame.width - checkIcon.frame.origin.x, 0)
    }
    
    func adjustFrameWithOffset(offset: CGFloat, duration: Double) {
        UIView.animateWithDuration(duration, animations: {
            var p = self.checkIcon.center
            p.x += offset
            self.checkIcon.center = p
            
            var frame = self.titleLabel.frame
            frame.size.width += offset
            self.titleLabel.frame = frame
            })
    }
}

class TodayItemCell: UITableViewCell {

    var titleView: ItemTitleView!
    var deleteBtn: UIButton!
    var deleteBtnContainer: UIView!
    var container: UIView!
    
    var delegate: TodayItemCellDelegate?
    var margin: CGFloat = 5
    
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
        redView.backgroundColor = UIColor.color(0xff9500)
        self.backgroundView = redView;
        
        var greenView = UIView(frame: redView.bounds);
        greenView.layer.cornerRadius = redView.layer.cornerRadius
        greenView.backgroundColor = UIColor.color(0x4cd964)
        self.selectedBackgroundView = greenView
        
        container = UIView(frame: redView.frame)
        container.clipsToBounds = true
        container.layer.cornerRadius = 5
        self.contentView.addSubview(container)
        
        titleView = ItemTitleView(frame: CGRectInset(container.bounds, 2, 2))
        container.addSubview(titleView)
        
        deleteBtn = UIButton(frame: CGRectMake(0, 0, 70, container.frame.height))
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.backgroundColor = UIColor.color(0xff3b30)
        var btnBk = deleteBtn.snapshot()
        deleteBtn.setBackgroundImage(btnBk, forState: UIControlState.Normal)
        deleteBtn.setTitle("Delete", forState: UIControlState.Normal)
        deleteBtn.addTarget(self, action: "delete", forControlEvents: UIControlEvents.TouchUpInside)
        
        deleteBtnContainer = UIView(x: 310, y: 0, width: 100, height: container.frame.height)
        deleteBtnContainer.backgroundColor = deleteBtn.backgroundColor
        deleteBtnContainer.addSubview(deleteBtn)
        
        container.addSubview(deleteBtnContainer)
        
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

        titleView.selected = selected
    }
    
    func updateWithItem(item:Item) {
        item.print()
        
        titleView.title = item.title
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
        if !onDeleting {
            self.showDeleteBtn(true)
        }
    }
    
    var test: UILabel!
    func showDeleteBtn(show: Bool) {
        if show {
            self.onDeleting = show
        }
        
        var offset: CGFloat = self.deleteBtn.frame.size.width
        self.deleteBtnContainer.alpha = 1
        if show {
            offset *= -1
            self.deleteBtnContainer.alpha = 0
        }
        
        var duration = 0.3
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: nil,animations:
            {
                self.titleView.adjustFrameWithOffset(offset, duration: duration)
                
                var frame = self.deleteBtnContainer.frame
                frame.origin.x += offset
                self.deleteBtnContainer.frame = frame
                
                self.deleteBtnContainer.alpha = show ? 1 : 0
                
            }, completion: {
                finished in
                self.onDeleting = show
            })
    }
    
    func delete() {
        self.delegate?.deleteItemForCell(self)
    }
    
    class func heightForTitle(title:NSString, withWidth width: CGFloat) -> CGFloat {
        return title.sizeWithFont(self.font, forWidth: width, lineBreakMode: NSLineBreakMode.ByCharWrapping).height
    }
}
