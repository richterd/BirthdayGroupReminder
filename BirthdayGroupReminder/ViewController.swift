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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var groups : [RHGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addressBook : RHAddressBook = self.appDelegate.addressBook
        addressBook.requestAuthorization(completion: { (granted: Bool, error: Error?) -> Void in
            if granted {
                self.appDelegate.addressBook = addressBook
                let addressBookGroups = addressBook.groups as! [RHGroup]
                for addressBookGroup in addressBookGroups{
                    self.groups.append(addressBookGroup)
                }
            }
            DispatchQueue.main.async(execute: {
                //Reload tableView on the main thread
                self.tableView!.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupTableViewCell
        
        //cell.isSelected = contains(appDelegate.selectedGroups, groups[indexPath.row].recordID)
        cell.isSelectedCell = appDelegate.selectedGroups.contains(groups[(indexPath as NSIndexPath).row].recordID)
        
        cell.groupName!.text = groups[(indexPath as NSIndexPath).row].name
        cell.recordID = groups[(indexPath as NSIndexPath).row].recordID
        let count = groups[(indexPath as NSIndexPath).row].count
        var countLabelText = String(count)
        if(count == 1){
            countLabelText += " person"
        } else{
            countLabelText += " people"
        }
        cell.countLabel!.text = countLabelText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : GroupTableViewCell = self.tableView!.cellForRow(at: indexPath) as! GroupTableViewCell
        if cell.isSelectedCell{
            cell.isSelectedCell = false
            if appDelegate.selectedGroups.contains(cell.recordID){
                appDelegate.selectedGroups.remove(at: appDelegate.selectedGroups.index(of: cell.recordID)!)
            }
        }else{
            cell.isSelectedCell = true
            if !appDelegate.selectedGroups.contains(cell.recordID){
                appDelegate.selectedGroups.append(cell.recordID)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedGroupsChanged"), object: self)
    }
}

