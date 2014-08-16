//
//  TodayItemCell.swift
//  Today
//
//  Created by Aldrich Huang on 8/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

import UIKit

protocol TodayItemCellDelegate {
    func showDetailForCell(cell: TodayItemCell)
    func deleteSelectedForCell(cell: TodayItemCell)
}

class TodayItemCell: UITableViewCell {

    var titleLabel: UILabel!
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
        
        var redView = UIView(frame: CGRectMake(5, 5, 310, 52))
        redView.layer.cornerRadius = 5;
        redView.backgroundColor = UIColor.redColor()
        self.backgroundView = redView;
        
        var greenView = UIView(frame: redView.bounds);
        greenView.layer.cornerRadius = redView.layer.cornerRadius
        greenView.backgroundColor = UIColor.greenColor()
        self.selectedBackgroundView = greenView
        
        titleLabel = UILabel(frame: CGRectMake(0, 0, 320, 66))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        self.contentView.addSubview(titleLabel)
        
        self.userInteractionEnabled = true
        
        var swipe = UISwipeGestureRecognizer(target: self, action: "showDetail")
        swipe.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipe)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "delete")
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
        titleLabel.frame = self.bounds
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
        titleLabel.text = item.title
    }
    
    func showDetail() {
        delegate?.showDetailForCell(self)
    }
    
    func delete() {
        
    }
    
    class func heightForTitle(title:NSString, withWidth width: CGFloat) -> CGFloat {
        return title.sizeWithFont(self.font, forWidth: width, lineBreakMode: NSLineBreakMode.ByCharWrapping).height
    }
}
