//
//  HouseViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 10/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HouseViewController: UITableViewController {

    var house: House!
    var ref: DatabaseReference!
    var components: [Component] = []
    var UID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "celulaDeReuso")
        self.navigationItem.title = house.label
        self.ref = Database.database().reference()
        retrieveComponents()
    }
    
    func retrieveComponents() {
        if let uid = house.ownerUid {
            self.UID = uid
        } else {
            self.UID = Auth.auth().currentUser!.uid
        }
        ref.child("houses").child(UID).child(house.label).child("components").observe(DataEventType.value, with: {(snapshot) in
            if let componentsDict = snapshot.value as? NSArray {
                self.components = []
                for component in componentsDict {
                    let aux = component as AnyObject
                    let component = Component()
                    
                    if let port = aux["port"] {
                        component.port = port as! Int
                    }
                    if let status = aux["status"] {
                        component.status = status as! String
                    }
                    if let label = aux["label"] {
                        component.label = label as! String
                    }
                    if let desc = aux["desc"] {
                        component.desc = desc as! String
                    }
                    self.components.append(component)
                }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return components.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaDeReuso", for: indexPath) as! CustomCell
        cell.setupWithModel(model: components[indexPath.row])
        cell.delegate = self
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.ref.child("houses").child(UID).child(house.label).child("components").child((indexPath.row).description).removeValue()
        }
    }

}

extension HouseViewController: CustomCellDelegate {
    func didTappedSwitch(cell: CustomCell) {
        let indexPath = tableView.indexPath(for: cell)
        let index: String = (indexPath?.row)!.description
        ref.child("houses").child(self.UID).child(house.label).child("components").child(index).child("status").setValue(cell.changeSwitch.isOn ? "on" : "off")
    }
}
