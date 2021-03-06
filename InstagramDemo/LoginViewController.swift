//
//  LoginViewController.swift
//  InstagramDemo
//
//  Created by Bconsatnt on 3/19/17.
//  Copyright © 2017 Bconsatnt. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignup(_ sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = username.text
        newUser.password = password.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Signup success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: username.text!, password: password.text!) { (user:PFUser?, error:Error?) in
            if user != nil {
                print("Login success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Login fail")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
