//
//  BGRAdressBook.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 16.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class BGRAdressBook: NSObject {
    
    var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func usersSortedByBirthday(selectedGroups : [ABRecordID]) -> [RHPerson]{
        let addressBook = delegate.addressBook
        var users : [RHPerson] = []
        for groupID : ABRecordID in selectedGroups{
            let group : RHGroup = addressBook.groupForABRecordID(groupID)
            let friends = group.members
            for friend : AnyObject in friends{
                let user = friend as! RHPerson
                if ((user.birthday) != nil){
                    users.append(friend as! RHPerson)
                }
            }
        }
        //Sort by birthday
        users.sortInPlace(){
            let leftDate : NSDate = $0.birthday
            let rightDate : NSDate = $1.birthday
            let left = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: leftDate)
            let right = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: rightDate)
            let current = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
            
            let lday = left.day
            var lmonth = left.month
            let rday = right.day
            var rmonth = right.month
            //Shift dates depending on current date
            if(lmonth < current.month){
                lmonth += 12
            } else if(lmonth == current.month){
                if(lday < current.day){
                    lmonth += 12
                }
            }
            
            if(rmonth < current.month){
                rmonth += 12
            } else if(rmonth == current.month){
                if(rday < current.day){
                    rmonth += 12
                }
            }
            
            //Now sort them
            var diff = lmonth - rmonth
            if(diff == 0){diff = lday - rday}
            if(diff < 0){
                return true
            }else{
                return false
            }
        }
        return users
    }
   
}
