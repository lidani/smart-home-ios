//
//  LoginViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 06/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let email = self.email_input.text;
        let password = self.password_input.text;
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if (user != nil && error == nil) {
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            } else if (user == nil && error != nil) {
                // Show error alert
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
