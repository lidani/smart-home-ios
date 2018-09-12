//
//  CustomCell.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 11/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func didTappedSwitch(cell: CustomCell)
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var changeSwitch: UISwitch!
    var delegate: CustomCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func swithValueChanged(_ sender: Any) {
        delegate.didTappedSwitch(cell: self)
    }
    
    func setupWithModel(model: Component) {
        label.text = model.label
        changeSwitch.setOn(model.status == "on", animated: true)
    }
    
}
