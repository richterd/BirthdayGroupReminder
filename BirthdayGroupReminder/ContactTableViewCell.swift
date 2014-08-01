//
//  ContactTableViewCell.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 15.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var pic : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var birthday : UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
