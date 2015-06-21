//
//  BabblesListViewController.swift
//  babblingTogether1
//
//  Created by Macbook Pro Retina on 2015-06-20.
//  Copyright (c) 2015 Codopedia. All rights reserved.
//

import UIKit
import Parse

class BabblesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    //All the sounds saved at parse.com are PFObjects.
    var babblesArray : [PFObject] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var babblesQuery = PFQuery(className: "Babble");
        babblesQuery.whereKeyExists("Audio");
        babblesQuery.includeKey("User");
        
        babblesQuery.findObjectsInBackgroundWithBlock {
            (downLoadedBabbles, error) -> Void in
            if error == nil{
                self.babblesArray = downLoadedBabbles as! [PFObject]
                self.tableView.reloadData();
            }
            else{
                println("Sorrey, the list of babbles was not downloded from parse.com");
            }
        }
    }//function viewDidAppear ends here.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.babblesArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var babble =  self.babblesArray[indexPath.row];
        var babbler = babble["User"] as! PFUser;
        var cell = UITableViewCell();
        cell.textLabel!.text = babbler["username"] as? String;
        return cell;
    }
    
    @IBAction func buttonLogoutTapped(sender: AnyObject) {

            PFUser.logOut();
        self.dismissViewControllerAnimated(true, completion: nil);
            //var currentUser = PFUser.currentUser();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
