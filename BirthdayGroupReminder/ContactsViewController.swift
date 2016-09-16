//
//  ContactsViewController.swift
//  BirthdayGroupReminder
//
//  Created by Daniel Richter on 15.07.14.
//  Copyright (c) 2014 Daniel Richter. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView : UITableView?

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var users : [RHPerson] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTableView()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name(rawValue: "selectedGroupsChanged"), object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func updateTableView(){
        let addressBook : RHAddressBook = self.appDelegate.addressBook
        let myAddressBook : BGRAdressBook = BGRAdressBook()
        addressBook.requestAuthorization(completion: { (granted: Bool, error: Error?) -> () in
            if granted {
                self.users = myAddressBook.usersSortedByBirthday(self.appDelegate.selectedGroups)
                if(self.users.count == 0){
                    let alert = UIAlertView(title: "No Users", message: "Please select at least one group in the 'more' tab.", delegate: self, cancelButtonTitle: "OK")
                    DispatchQueue.main.async(execute: {
                            alert.show()
                        })
                }
                //Remove unwanted entries from selected groups
                var newSelectedGroups : [ABRecordID] = []
                for group : ABRecordID in self.appDelegate.selectedGroups{
                    let foundGroup = addressBook.group(forABRecordID: group)
                    if((foundGroup) != nil){
                        newSelectedGroups.append(group)
                    }
                }
                self.appDelegate.selectedGroups = newSelectedGroups
            }
            DispatchQueue.main.async(execute: {
                //Reload tableView on the main thread
                self.tableView!.reloadData()
                })
            })
    }
    
    func alertView(_ alertView: UIAlertView!,
        clickedButtonAtIndex buttonIndex: Int){
            self.tabBarController!.selectedIndex = 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        let user = users[(indexPath as NSIndexPath).row]
        cell.name!.text = user.name
        cell.pic!.image = user.image(with: kABPersonImageFormatThumbnail)
        if(cell.pic!.image == nil){
            cell.pic!.image = UIImage(named: "default.jpg")
        }
        cell.pic!.layer.masksToBounds = true
        cell.pic!.layer.cornerRadius = 25
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.birthday!.text = dateFormatter.string(from: user.birthday)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
