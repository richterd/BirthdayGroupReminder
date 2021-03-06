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
    
    func createNotifications(_ selectedGroups : [ABRecordID]){
        //Remove old notifications
        UIApplication.shared.cancelAllLocalNotifications();

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
    
    func addNotificationForUser(_ user : RHPerson, withWarning warning : Bool){
        let birthday = (Calendar.current as NSCalendar).components([.day, .month, .year], from: user.birthday)
        var thisBirthday = (Calendar.current as NSCalendar).components([.hour, .minute, .second, .day, .month, .year], from: Date())
        
        //Pehaps you want to skip todays birthday after closing the app
        /*
        if(birthday.day == thisBirthday.day && birthday.month == thisBirthday.month){
            print("Skipped birthday because it was today")
            return
        }*/
        
        //Correct Year if needed
        if(birthday.month! < thisBirthday.month!){
            thisBirthday.year = thisBirthday.year! + 1
        } else if(birthday.month == thisBirthday.month){
            if(birthday.day! < thisBirthday.day!){
                thisBirthday.year = thisBirthday.year! + 1
            }
        }
        thisBirthday.hour = 9
        thisBirthday.minute = 0
        thisBirthday.second = 0
        thisBirthday.month = birthday.month
        thisBirthday.day = birthday.day
        
        
        let date = Calendar.current.date(from: thisBirthday)
        var text = ""
        if(warning){
            //change date to one day earlier
            var comp = DateComponents()
            comp.day = -1
            let yesterdayDate = (Calendar.current as NSCalendar).date(byAdding: comp, to: Date(), options: [])
            let yesterday = (Calendar.current as NSCalendar).components([.day, .month], from: yesterdayDate!)
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
        localNotification.timeZone = TimeZone.current
        localNotification.alertBody = text
        localNotification.hasAction = false
        
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        self.currentNotificationCount += 1
    }
}
