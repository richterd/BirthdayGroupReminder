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
        var myAddressBook = BGRAdressBook()
        var users : [RHPerson] = myAddressBook.usersSortedByBirthday(selectedGroups)
        
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
        var birthday = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: user.birthday)
        var thisBirthday = NSCalendar.currentCalendar().components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate.date())
        
        //thisBirthday.minute = (thisBirthday.minute + 1) % 60
        //Skipp Todays Birthdays
        if(birthday.day == thisBirthday.day && birthday.month == thisBirthday.month){
            println("Skipped birthday because it was today")
            return
        }
        
        //Correct Year if needed
        if(birthday.month < thisBirthday.month){
            thisBirthday.year = thisBirthday.year + 1
        } else if(birthday.month == thisBirthday.month){
            if(birthday.day < thisBirthday.day){
                thisBirthday.year = thisBirthday.year + 1
                println("Corrected day")
            }
        }
        thisBirthday.hour = 9
        thisBirthday.minute = 0
        thisBirthday.second = 0
        thisBirthday.month = birthday.month
        thisBirthday.day = birthday.day
        
        
        var date = NSCalendar.currentCalendar().dateFromComponents(thisBirthday)
        var text = ""
        if(warning){
            //change date to one day earlier
            var comp = NSDateComponents()
            comp.day = -1
            var yesterdayDate = NSCalendar.currentCalendar().dateByAddingComponents(comp, toDate: NSDate.date(), options: nil)
            var yesterday = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth, fromDate: yesterdayDate)
            thisBirthday.day = yesterday.day
            thisBirthday.month = yesterday.month
            text = "Bitte App starten um Geburstage zu aktualisieren"
            println("Added warning")
        } else{
            text = user.name + " hat heute Geburstag"
            println("Added birthday notification for " + user.name)
        }
        //Setup Notification
        var localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = text
        localNotification.hasAction = false
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        self.currentNotificationCount++
    }
}
