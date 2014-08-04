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
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        container = UIView(frame: CGRectMake(5, 2, 310, 62))
        container.layer.cornerRadius = 5;
        
        titleLabel = UILabel(frame: container.bounds)
        titleLabel.textAlignment = NSTextAlignment.Center
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            container.backgroundColor = UIColor.greenColor()
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            container.backgroundColor = UIColor.redColor()
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func updateWithItem(item:Item) {
        titleLabel.text = item.title
    }
    
    func showDetail() {
        delegate?.showDetailForCell(self)
    }
}
