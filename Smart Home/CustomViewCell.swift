//
//  CustomViewCell.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 11/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit

protocol CustomViewCellDelegate {
    func didTappedButton(cell: CustomViewCell)
}

class CustomViewCell: UITableViewCell {

    var delegate: CustomViewCellDelegate!
    
    @IBOutlet weak var house_label: UILabel!
    @IBOutlet weak var hash_label: UILabel!
    
    @IBAction func onClickCopyButton(_ sender: Any) {
        delegate.didTappedButton(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWithModel(model: Admin) {
        house_label.text = model.house_title
        hash_label.text = model.hashKey
    }
    
}
