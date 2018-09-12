//
//  SettingsViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 10/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    var user: User!
    @IBOutlet weak var name_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        name_label.text = user.displayName != nil ? user.displayName : user.email
    }
 
    @IBAction func doLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "settingsToLogin", sender: self)
        } catch {
            Toast(msg: "Erro inesperado", view: self.view).showAlert()
        }
    }
}
