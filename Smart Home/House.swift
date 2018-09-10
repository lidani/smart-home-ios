//
//  House.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 10/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseDatabase

class House {
    
    var label: String
    var components: NSArray
    
    init() {
        self.label = ""
        self.components = []
    }
    
    init?(label: String, components: NSArray) {
        self.label = label
        self.components = components
    }
}

class Component {
    
    var label: String
    var port: Int
    var desc: String
    var status: String
    
    init(label: String, port: Int, desc: String, status: String) {
        self.label = label
        self.port = port
        self.desc = desc
        self.status = status
    }
}
