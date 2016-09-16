//
//  ContactTableViewCell.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 15.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var pic : UIImageView?
    @IBOutlet var name : UILabel?
    @IBOutlet var birthday : UILabel?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
