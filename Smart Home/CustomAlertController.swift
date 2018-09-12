//
//  CustomAlertController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 11/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit

class CustomAlertController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onClickClose(_ sender: Any) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        
    }

}
