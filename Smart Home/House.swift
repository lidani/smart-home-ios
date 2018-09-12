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
    var ownerUid: String?
    
    init() {
        self.label = ""
        self.components = []
        self.ownerUid = nil
    }
}

class Component {
    
    var label: String
    var port: Int
    var desc: String
    var status: String
    
    init() {
        self.label = ""
        self.port = 0
        self.desc = ""
        self.status = ""
    }
}

class Admin {
    
    var hashKey: String
    var house_title: String
    var ownerUid: String
    
    init() {
        self.hashKey = ""
        self.house_title = ""
        self.ownerUid = ""
    }
}
