//
//  ContactsViewController.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 15.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView : UITableView!

    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var users : [RHPerson] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTableView()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: "selectedGroupsChanged", object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func updateTableView(){
        var addressBook : RHAddressBook = self.appDelegate.addressBook
        var myAddressBook : BGRAdressBook = BGRAdressBook()
        addressBook.requestAuthorizationWithCompletion({
            (granted: Bool, error: NSError!) -> () in
            if granted {
                self.users = myAddressBook.usersSortedByBirthday(self.appDelegate.selectedGroups)
                if(self.users.count == 0){
                    var alert = UIAlertView(title: "No Users", message: "Please select at least one group in the 'more' tab.", delegate: self, cancelButtonTitle: "OK")
                    dispatch_async(dispatch_get_main_queue(), {
                            alert.show()
                        })
                }
                //Remove unwanted entries from selected groups
                var i = 0
                var newSelectedGroups : [ABRecordID] = []
                for group : ABRecordID in self.appDelegate.selectedGroups{
                    var foundGroup = addressBook.groupForABRecordID(group)
                    if(foundGroup){
                        newSelectedGroups.append(group)
                    }
                }
                self.appDelegate.selectedGroups = newSelectedGroups
            }
            dispatch_async(dispatch_get_main_queue(), {
                //Reload tableView on the main thread
                self.tableView.reloadData()
                })
            })
    }
    
    func alertView(alertView: UIAlertView!,
        clickedButtonAtIndex buttonIndex: Int){
            self.tabBarController.selectedIndex = 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as ContactTableViewCell
        var user = users[indexPath.row]
        cell.name.text = user.name
        cell.pic.image = user.imageWithFormat(kABPersonImageFormatThumbnail)
        if(!cell.pic.image){
            cell.pic.image = UIImage(named: "default.jpg")
        }
        cell.pic.layer.masksToBounds = true
        cell.pic.layer.cornerRadius = 25
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.birthday.text = dateFormatter.stringFromDate(user.birthday)
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
