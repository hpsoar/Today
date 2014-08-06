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

    var titleLabel: UILabel
    var container: UIView
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
        container = UIView(frame: CGRectMake(5, 2, 310, 62))
        container.layer.cornerRadius = 5;
        
        titleLabel = UILabel(frame: container.bounds)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        container.addSubview(titleLabel)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(container)
        
        var longPress = UILongPressGestureRecognizer(target: self, action: "showDetail")
        self.userInteractionEnabled = true
        self.addGestureRecognizer(longPress)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.frame = CGRectInset(self.contentView.bounds, 5, 5);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            container.backgroundColor = cellColorSelected
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            container.backgroundColor = cellColor
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func updateWithItem(item:Item) {
        titleLabel.text = item.title
    }
    
    func showDetail() {
        delegate?.showDetailForCell(self)
    }
    
    class func heightForTitle(title:NSString, withWidth width: CGFloat) -> CGFloat {
        return title.sizeWithFont(self.font, forWidth: width, lineBreakMode: NSLineBreakMode.ByCharWrapping).height
    }
}
