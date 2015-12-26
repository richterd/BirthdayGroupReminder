//
//  GroupTableViewCell.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 11.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet var groupName : UILabel?
    @IBOutlet var countLabel: UILabel?
    
    var recordID : ABRecordID = -1
    
    var isSelectedCell : Bool = false{
        didSet{
            if isSelectedCell{
                self.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else{
                self.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
