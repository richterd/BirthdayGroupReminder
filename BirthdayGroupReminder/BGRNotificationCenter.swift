//
//  BGRNotificationCenter.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 13.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class BGRNotificationCenter: NSObject {
    
    var maxNotificationCount = 50
    var currentNotificationCount = 0
    
    //var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    func createNotifications(selectedGroups : [ABRecordID]){
        //Remove old notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications();

        //get all users
        let myAddressBook = BGRAdressBook()
        let users : [RHPerson] = myAddressBook.usersSortedByBirthday(selectedGroups)
        
        for user in users{
            //Create the new once
            if(self.currentNotificationCount == self.maxNotificationCount){
                self.addNotificationForUser(user, withWarning: true)
                break
            } else{
                self.addNotificationForUser(user, withWarning: false)
            }
        }
    }
    
    func addNotificationForUser(user : RHPerson, withWarning warning : Bool){
        let birthday = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: user.birthday)
        let thisBirthday = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second, .Day, .Month, .Year], fromDate: NSDate())
        
        //thisBirthday.minute = (thisBirthday.minute + 1) % 60
        //Skipp Todays Birthdays
        if(birthday.day == thisBirthday.day && birthday.month == thisBirthday.month){
            print("Skipped birthday because it was today")
            return
        }
        
        //Correct Year if needed
        if(birthday.month < thisBirthday.month){
            thisBirthday.year = thisBirthday.year + 1
        } else if(birthday.month == thisBirthday.month){
            if(birthday.day < thisBirthday.day){
                thisBirthday.year = thisBirthday.year + 1
                print("Corrected day")
            }
        }
        thisBirthday.hour = 9
        thisBirthday.minute = 0
        thisBirthday.second = 0
        thisBirthday.month = birthday.month
        thisBirthday.day = birthday.day
        
        
        let date = NSCalendar.currentCalendar().dateFromComponents(thisBirthday)
        var text = ""
        if(warning){
            //change date to one day earlier
            let comp = NSDateComponents()
            comp.day = -1
            let yesterdayDate = NSCalendar.currentCalendar().dateByAddingComponents(comp, toDate: NSDate(), options: [])
            let yesterday = NSCalendar.currentCalendar().components([.Day, .Month], fromDate: yesterdayDate!)
            thisBirthday.day = yesterday.day
            thisBirthday.month = yesterday.month
            text = "Bitte App starten um Geburstage zu aktualisieren"
            print("Added warning")
        } else{
            text = user.name + " hat heute Geburstag"
            print("Added birthday notification for " + user.name)
        }
        //Setup Notification
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = text
        localNotification.hasAction = false
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        self.currentNotificationCount++
    }
}
