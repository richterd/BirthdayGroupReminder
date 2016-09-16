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
        selectedGroups.removeAll(keepingCapacity: true)
        let stored : AnyObject? = UserDefaults.standard.object(forKey: "selectedGroups") as AnyObject?
        if (stored != nil){
            let theArray = stored as! [NSNumber]
            for id in theArray{
                selectedGroups.append(id.int32Value as ABRecordID)
            }
        }
        return selectedGroups
    }
    
    func saveToFile(_ selectedGroups : [ABRecordID]){
        var preStoreGroups : [NSNumber] = []
        for groupID in selectedGroups{
            let value : NSNumber = NSNumber(value: groupID as Int32)
            preStoreGroups.append(value)
        }
        UserDefaults.standard.removeObject(forKey: "selectedGroups")
        UserDefaults.standard.set(preStoreGroups, forKey: "selectedGroups")
        UserDefaults.standard.synchronize()
    }
}
