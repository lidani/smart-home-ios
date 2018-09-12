//
//  ViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 06/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                self.performSegue(withIdentifier: "controllerToMain", sender: self)
            } else {
                self.performSegue(withIdentifier: "controllerToLogin", sender: self)
            }
        }
    }
}

