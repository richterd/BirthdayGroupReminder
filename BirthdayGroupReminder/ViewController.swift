//
//  ViewController.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 11.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView?
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var groups : [RHGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addressBook : RHAddressBook = self.appDelegate.addressBook
        addressBook.requestAuthorizationWithCompletion({
            (granted: Bool, error: NSError!) -> () in
            if granted {
                self.appDelegate.addressBook = addressBook
                let addressBookGroups = addressBook.groups
                for object : AnyObject in addressBookGroups{
                    let addressBookGroup = object as! RHGroup
                    self.groups.append(addressBookGroup)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                //Reload tableView on the main thread
                self.tableView!.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! GroupTableViewCell
        
        //cell.isSelected = contains(appDelegate.selectedGroups, groups[indexPath.row].recordID)
        cell.isSelectedCell = appDelegate.selectedGroups.contains(groups[indexPath.row].recordID)
        
        cell.groupName!.text = groups[indexPath.row].name
        cell.recordID = groups[indexPath.row].recordID
        let count = groups[indexPath.row].count
        var countLabelText = String(count)
        if(count == 1){
            countLabelText += " person"
        } else{
            countLabelText += " people"
        }
        cell.countLabel!.text = countLabelText
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : GroupTableViewCell = self.tableView!.cellForRowAtIndexPath(indexPath) as! GroupTableViewCell
        if cell.isSelectedCell{
            cell.isSelectedCell = false
            if appDelegate.selectedGroups.contains(cell.recordID){
                appDelegate.selectedGroups.removeAtIndex(appDelegate.selectedGroups.indexOf(cell.recordID)!)
            }
        }else{
            cell.isSelectedCell = true
            if !appDelegate.selectedGroups.contains(cell.recordID){
                appDelegate.selectedGroups.append(cell.recordID)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName("selectedGroupsChanged", object: self)
    }
}

