//
//  Toast.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 12/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import Foundation
import UIKit

class Toast {
    
    var msg: String!
    var view: UIView!
    
    init(msg: String, view: UIView) {
        self.msg = msg
        self.view = view
    }
    
    func showAlert() {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height/2 + 130, width: 350, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = self.msg
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
