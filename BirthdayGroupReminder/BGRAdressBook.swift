//
//  BGRAdressBook.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 16.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class BGRAdressBook: NSObject {
    
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func usersSortedByBirthday(_ selectedGroups : [ABRecordID]) -> [RHPerson]{
        let addressBook = delegate.addressBook
        var users : [RHPerson] = []
        for groupID : ABRecordID in selectedGroups{
            let group : RHGroup = addressBook.group(forABRecordID: groupID)
            let friends = group.members as! [RHPerson]
            for user in friends{
                if ((user.birthday) != nil){
                    users.append(user)
                }
            }
        }
        //Sort by birthday
        users.sort(){
            let leftDate : Date = $0.birthday
            let rightDate : Date = $1.birthday
            let left = (Calendar.current as NSCalendar).components([.day, .month, .year], from: leftDate)
            let right = (Calendar.current as NSCalendar).components([.day, .month, .year], from: rightDate)
            let current = (Calendar.current as NSCalendar).components([.day, .month, .year], from: Date())
            
            //Its save to unwrap the information here
            let lday = left.day!
            var lmonth = left.month!
            let rday = right.day!
            var rmonth = right.month!
            
            //Shift dates depending on current date
            if(lmonth < current.month!){
                lmonth += 12
            } else if(lmonth == current.month){
                if(lday < current.day!){
                    lmonth += 12
                }
            }
            
            if(rmonth < current.month!){
                rmonth += 12
            } else if(rmonth == current.month){
                if(rday < current.day!){
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
