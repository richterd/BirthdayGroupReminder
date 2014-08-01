//
//  BGRStorage.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 13.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class BGRStorage: NSObject {
    func loadFromFile() -> [ABRecordID]{
        var selectedGroups : [ABRecordID] = []
        selectedGroups.removeAll(keepCapacity: true)
        let stored : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("selectedGroups")
        if stored{
            let theArray = stored as NSArray
            for anObject : AnyObject in theArray{
                let id : NSNumber = anObject as NSNumber
                selectedGroups.append(id.intValue as ABRecordID)
            }
        }
        return selectedGroups
    }
    
    func saveToFile(selectedGroups : [ABRecordID]){
        var preStoreGroups : [NSNumber] = []
        for groupID in selectedGroups{
            var value : NSNumber = NSNumber.numberWithInt(groupID)
            preStoreGroups.append(value)
        }
        NSUserDefaults.standardUserDefaults().removeObjectForKey("selectedGroups")
        NSUserDefaults.standardUserDefaults().setObject(preStoreGroups.bridgeToObjectiveC(), forKey: "selectedGroups")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
