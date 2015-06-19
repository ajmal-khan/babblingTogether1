//
//  LoginWiewController.swift
//  babblingTogether1
//
//  Created by Macbook Pro Retina on 2015-06-18.
//  Copyright (c) 2015 Codopedia. All rights reserved.
//

import UIKit
import Parse
import Foundation

class LoginWiewController: UIViewController {


    @IBOutlet weak var buttonResetPassword: UIButton!
    @IBOutlet weak var buttonLoginWithEmail: UIButton!
    @IBOutlet weak var buttonLogOut: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if ([FBSDKAccessToken currentAccessToken]) {
            // User is logged in, do work such as go to next view controller.
        //}
        
        doStartUpWork();
        
    }//function viewDidLoad ends here.
    
    func doStartUpWork(){
        
        var currentUser = PFUser.currentUser();
        if currentUser != nil{
            // Let the user go on to the next view controller.
            self.errorLabel.hidden = false;
            self.errorLabel.textColor = UIColor.purpleColor();
            self.errorLabel.text = "You are already logged in on this device.";
            self.buttonLoginWithEmail.hidden = true;
            self.buttonSignUp.hidden = true;
            self.emailTextField.hidden = true;
            self.passwordTextField.hidden = true;
            self.buttonLogOut.hidden = false;
        }
        else{
            //Show the sign up or log in screen.
            self.buttonLogOut.hidden = true;
            self.buttonSignUp.hidden = false;
            self.buttonLoginWithEmail.hidden = false;
            self.emailTextField.text = "";
            self.emailTextField.hidden = false;
            self.passwordTextField.text = "";
            self.passwordTextField.hidden = false;
            self.errorLabel.hidden = true;//As there is no error now.
        }
        
    }//function doStartUpWork ends here
    
    
    @IBAction func buttonLogOutTapped(sender: AnyObject) {
        PFUser.logOut();
        self.emailTextField.text = "";
        self.passwordTextField.text = "";
        doStartUpWork();
        //var currentUser = PFUser.currentUser();
    }

    
    @IBAction func buttonLoginWithEmailTapped(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(self.emailTextField.text, password: self.passwordTextField.text){
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil{
                self.errorLabel.hidden = false;
                self.errorLabel.textColor = UIColor.blueColor();
                self.errorLabel.text = "You have been logged in!";
                self.buttonLoginWithEmail.hidden = true;
                self.buttonLogOut.hidden = false;
                self.buttonSignUp.hidden = true;
                self.emailTextField.text = "";
                self.emailTextField.hidden = true;
                self.passwordTextField.text = "";
                self.passwordTextField.hidden = true;
            } else {
                self.errorLabel.hidden = false;
                self.errorLabel.textColor = UIColor.redColor();
                self.errorLabel.text = "Either your password or email is not correct!";
            }
        }
    }//function buttonLoginWithEmailTapped ends here.
    
    @IBAction func buttonLoginWithTwitterTapped(sender: AnyObject) {
        
        PFTwitterUtils.initializeWithConsumerKey("3baASxPrkrLUUPqlyPYksU9gs", consumerSecret: "25Tup6JXJVs7nPNODxmHjJGxyPPxFdMVxrsFdBrChOJ51OS5hM")
        
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    //println("User signed up and logged in with Twitter!")
                } else {
                    //println("User logged in with Twitter!")
                }
            } else {
                //println("Uh oh. The user cancelled the Twitter login.")
            }
        }
        
    }//function buttonLoginWithTwitterTapped ends here.
    
    @IBAction func buttonSignUpTapped(sender: AnyObject) {
        
        var newUser = PFUser();
        newUser.username = self.emailTextField.text;
        newUser.password = self.passwordTextField.text;
        newUser.email = self.emailTextField.text;
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error{
                let errorString = error.userInfo?["error"] as? NSString;
                //show the errorString somewhere and let the user try again.
                //println(errorString);
                self.errorLabel.hidden = false;
                self.errorLabel.textColor = UIColor.redColor();
                self.errorLabel.text = "Email already taken!";
            } else{
                self.errorLabel.hidden = false;
                self.errorLabel.textColor = UIColor.greenColor();
                self.errorLabel.text = "Congritualtions! You can use the app now!";
                //println("You have successfully signed up. An account was made for you.");
                //Success, let them use the app now! Let them go to the next navigation controller.
            }
        }//@
        
    }//function buttonSignUpTapped ends here.
    
    
    @IBAction func buttonResetPasswordTapped(sender: AnyObject) {
        
        PFUser.requestPasswordResetForEmail(self.emailTextField.text);
    }
    
}//class LoginWiewController ends here.



/*parse keys
// https://www.parse.com/apps/babblingtogether1/edit#keys

Application ID:
AI5jpxBt0dTeKGHcGZZh1uTedKycxLoKwwX7Og8O

Client Key:
wGP4rk25MIqb7t1lLbMOLqWUoIkuUuoTpZsPe4v0

Java script key:
T8xzgJ5vdUm5AAV03Dqo9hhdj2el8Iz0lJh1nBp3

Master key:
MlQpkuaMb3GcyE2PO75L9l7YiTteWCHJpArc2kD7

REST API key:
lwn7YDzXepPGurGyCfz6J5qyrh2Pu1zYWuARJQI7

Webhook key:
Z98dHZMc5dMklJ27Vsko2F0nuKYALHaDnL5EFQ2k

.Dotnet key:
9gad4KeqYKyR2om0JkCMKzQLBbrhr8FwgUmMm2up

*/

/*
//Twitter keys

Consumer Key (API Key)	3baASxPrkrLUUPqlyPYksU9gs
Consumer Secret (API Secret)	25Tup6JXJVs7nPNODxmHjJGxyPPxFdMVxrsFdBrChOJ51OS5hM

*/

/*
Facebook 
App ID:
688553447916176

App Secret:
72748d6d411b71cb897f00d226feecaa

*/

/*
git instructions:

Ajmal-Khans-Macbook-Pro-Retina:babblingTogether1 macbookproretina$ git add .

Ajmal-Khans-Macbook-Pro-Retina:babblingTogether1 macbookproretina$ git commit -m "Added error lable so that error is shown in case the email is already taken."

Ajmal-Khans-Macbook-Pro-Retina:babblingTogether1 macbookproretina$ git push origin master

Ajmal-Khans-Macbook-Pro-Retina:babblingTogether1 macbookproretina$ git status

*/