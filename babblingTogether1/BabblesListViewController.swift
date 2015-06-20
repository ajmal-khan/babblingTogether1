//
//  BabblesListViewController.swift
//  babblingTogether1
//
//  Created by Macbook Pro Retina on 2015-06-20.
//  Copyright (c) 2015 Codopedia. All rights reserved.
//

import UIKit
import Parse

class BabblesListViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
