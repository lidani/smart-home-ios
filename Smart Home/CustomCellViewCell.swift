//
//  CustomCellViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 11/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit

class CustomCellViewCell: UITableViewCell {
        
    @IBOutlet weak var component_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
    }
    
}
