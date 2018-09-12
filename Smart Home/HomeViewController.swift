//
//  MainViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 06/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UITableViewController {

    var user: User!
    var ref: DatabaseReference!
    var houses: [House]! = []
    
    @IBOutlet weak var toolbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "add_user"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addHouseFromHashKey(_:)), for: UIControlEvents.touchUpInside)
 
        toolbar.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHouse(_:))), animated: true)
        toolbar.setLeftBarButton(UIBarButtonItem(customView: button), animated: true)

        user = Auth.auth().currentUser!;
        ref = Database.database().reference()
        self.retrieveHouses()
    }
    
    func retrieveHouses() -> Void {
        ref.child("houses").child(self.user.uid).observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            self.houses = []
            let houseDict = snapshot.value as? NSDictionary
            if houseDict != nil {
                for house in houseDict! {
                    let aux = (house.value as AnyObject)
                    let house = House()
                    if let components = aux["components"] {
                        if (components != nil) {
                            house.components = components as! NSArray
                        }
                    }
                    if let title = aux["title"] {
                        if (title != nil) {
                            house.label = title as! String
                        }
                    }
                    if let ownerUid = aux["ownerUid"] {
                        if (ownerUid != nil) {
                            house.ownerUid = ownerUid as? String
                        }
                    }
                    self.houses.append(house)
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            Toast(msg: error.localizedDescription, view: self.view).showAlert()
        }
    }
    
    func retrieveAdminHouses(adm: Admin) -> Void {
        ref.child("houses").child(adm.ownerUid).child(adm.house_title).observe(.value, with: {(snapshot) in
            let h = snapshot.value as AnyObject
            let house = House()
            if let title = h["title"] {
                if (title != nil) {
                    house.label = title as! String
                }
            }
            if let components = h["components"] {
                if (components != nil) {
                    house.components = components as! NSArray
                }
            }
            house.ownerUid = adm.ownerUid
            self.ref.child("houses").child(self.user.uid).child(house.label).setValue(["title": house.label, "components": house.components, "ownerUid": house.ownerUid ?? ""]) { (error, ref) -> Void in
                if error != nil {
                    Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                } else {
                    Toast(msg: "Casa adicionada com sucesso", view: self.view).showAlert()
                }
            };
        }) { (error) in
            Toast(msg: error.localizedDescription, view: self.view).showAlert()
        }
    }
    
    @objc func addHouse(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Adicionar uma nova casa", message: "Esolha o nome e adicione sua casa", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Nome da casa"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: UIAlertActionStyle.default,
            handler: { (UIAlertAction) -> Void in
                let houseName = alert.textFields![0].text!
                self.ref.child("houses").child(self.user.uid).child(houseName).setValue(["title": houseName]) { (error, ref) -> Void in
                    if error != nil {
                        Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                    } else {
                        Toast(msg: "Casa adicionada com sucesso", view: self.view).showAlert()
                    }
                };
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addHouseFromHashKey(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Adiconar uma nova casa", message: "Adicione uma nova casa a partir de um HashKey", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "HashKey"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: UIAlertActionStyle.default,
            handler: { (UIAlertAction) -> Void in
                let hashkey = alert.textFields![0].text!
                
                self.ref.child("admins").child(hashkey).observeSingleEvent(of: .value, with: {(snap) in
                    if let adminDict = snap.value as? NSDictionary {
                        for admin in adminDict {
                            let aux = admin.value as AnyObject
                            let adm = Admin()
                            if let ownerUid = aux["ownerUid"] {
                                if (ownerUid != nil) {
                                    adm.ownerUid = ownerUid as! String
                                }
                            }
                            if let hashKey = aux["hashKey"] {
                                adm.hashKey = hashKey as! String
                            }
                            if let house_title = aux["house_title"] {
                                adm.house_title = house_title as! String
                            }
                            
                            if (adm.ownerUid == self.user.uid) {
                                Toast(msg: "Você nao pode adicionar sua casa própria", view: self.view).showAlert()
                            } else {
                                self.retrieveAdminHouses(adm: adm)
                            }
                        }
                    }
                }) { (error) in
                    Toast(msg: error.localizedDescription, view: self.view).showAlert()
                }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToHouseView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let houseViewController = segue.destination as! HouseViewController
                houseViewController.house = self.houses[indexPath.row]
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        cell.textLabel?.text = houses[indexPath.row].label
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let house = houses[indexPath.row]
            self.ref.child("houses").child(user.uid).child(house.label).removeValue() { (error, ref) -> Void in
                if error != nil {
                    Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                } else {
                    Toast(msg: "\(house.label) removida com sucesso", view: self.view).showAlert()
                }
            };
        }
    }

}
