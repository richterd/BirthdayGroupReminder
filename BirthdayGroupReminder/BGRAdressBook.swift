//
//  BGRAdressBook.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 16.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class BGRAdressBook: NSObject {
    
    var delegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    func usersSortedByBirthday(selectedGroups : [ABRecordID]) -> [RHPerson]{
        var addressBook = delegate.addressBook
        var users : [RHPerson] = []
        for groupID : ABRecordID in selectedGroups{
            var group : RHGroup = addressBook.groupForABRecordID(groupID)
            var friends = group.members
            for friend : AnyObject in friends{
                var user = friend as RHPerson
                if (user.birthday){
                    users.append(friend as RHPerson)
                }
            }
        }
        //Sort by birthday
        users.sort(){
            var leftDate : NSDate = $0.birthday
            var rightDate : NSDate = $1.birthday
            var left = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: leftDate)
            var right = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: rightDate)
            var current = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate.date())
            
            var lday = left.day
            var lmonth = left.month
            var rday = right.day
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
