//
//  LoginViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 06/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email], viewController: self) { (loginResult) in
            switch loginResult {
                case LoginResult.failed(let error):
                    print(error)
                case LoginResult.cancelled:
                    print("User cancelled login.")
                case LoginResult.success(_ , _ , let accessToken):
                    self.doFacebookLogin(token: accessToken.authenticationToken)
            }
        }
    }
    
    func doFacebookLogin(token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
            if (error == nil && authResult?.user != nil) {
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            }
        })
    }

}
