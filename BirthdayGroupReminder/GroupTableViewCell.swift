//
//  GroupTableViewCell.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 11.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet var groupName : UILabel!
    @IBOutlet var countLabel: UILabel!
    
    var recordID : ABRecordID = -1
    
    var isSelected : Bool = false{
        didSet{
            if isSelected{
                self.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else{
                self.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }
    
}
