//
//  AdminViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 10/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AdminViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hashes: [Admin] = []
    var houses: [House] = []
    var ref: DatabaseReference!
    var user: User!
    var pickerView: UIPickerView!
    
    @IBOutlet weak var toolbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.setLeftBarButtonItems([
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addComponent(_:)))
            ], animated: true)
        toolbar.setRightBarButtonItems([
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportHashKey(_:)))
            ], animated: true)
        
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        retrieveHashesKeys()
        retrieveHouses()
    }
    
    @objc func addComponent(_ sender: UIBarButtonItem) {
        let alertView = UIAlertController(
            title: "Adicionar componente",
            message: "\n\n\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        
        alertView.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Nome"
        })
        alertView.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Porta"
        })
        alertView.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Descrição (Opicional)"
        })
        
        pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 132))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(pickerView)
        
        let actionCancel = UIAlertAction(title: "Adicionar", style: UIAlertActionStyle.default, handler: { (_) in
            let index = self.pickerView.selectedRow(inComponent: 0)
            let selected = self.houses[index]
            let components: NSArray = self.houses[index].components

            let title = alertView.textFields![0].text!
            let port = Int(alertView.textFields![1].text!)!
            let desc = alertView.textFields![2].text!
            let status = "off"
            
            self.ref.child("houses").child(selected.ownerUid != nil ? selected.ownerUid! : self.user.uid).child(selected.label).child("components").child(String(components.count)).setValue(["label": title, "port": port, "desc": desc, "status": status]) { (error, ref) -> Void in
                if error != nil {
                    Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                } else {
                    Toast(msg: "Componente adicionado com sucesso", view: self.view).showAlert()
                }
            }
        })
        let actionOk = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertView.addAction(actionCancel)
        alertView.addAction(actionOk)
        
        present(alertView, animated: true, completion: { () -> Void in
            self.pickerView.frame.size.width = alertView.view.frame.size.width
        })
        
    }
    
    @objc func exportHashKey(_ sender: UIBarButtonItem) {
        let alertView = UIAlertController(
            title: "Compartilhar HashKey",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(pickerView)
        
        let actionOk = UIAlertAction(title: "Adicionar", style: UIAlertActionStyle.default, handler: { (_) in
            let selected = self.houses[self.pickerView.selectedRow(inComponent: 0)].label
            let hashKey = self.MD5(string: selected + self.user.uid + Date().description).map { String(format: "%02hhx", $0) }.joined()
            print(hashKey)
            self.ref.child("admins").child(hashKey).child(selected).setValue(["hashKey": hashKey, "house_title": selected, "ownerUid": self.user.uid]) { (error, ref) -> Void in
                if error != nil {
                    Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                } else {
                    Toast(msg: "HashKey adicionada com sucesso", view: self.view).showAlert()
                }
            }
        })
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertView.addAction(actionCancel)
        alertView.addAction(actionOk)
        
        present(alertView, animated: true, completion: { () -> Void in
            self.pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    
    func retrieveHouses() {
        ref.child("houses").child(user.uid).observe(.value, with: { (snap) in
            if snap.value.debugDescription != "Optional(<null>)" {
                let dict = snap.value as! NSDictionary
                self.houses = []
                for house in dict {
                    let aux = house.value as AnyObject
                    let house = House()
                    if let components = aux["components"] {
                        if (components != nil) {
                            house.components = components as! NSArray
                        }
                    }
                    if let title = aux["title"] {
                        house.label = title as! String
                    }
                    if let ownerUid = aux["ownerUid"] {
                        if (ownerUid != nil) {
                            house.ownerUid = ownerUid as? String
                        }
                    }
                    self.houses.append(house)
                }
            }
        })
    }
    
    @objc func cancelSelection(sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    func retrieveHashesKeys() {
        ref.child("admins").observe(.value, with: {(snap) in
            self.hashes = []
            for child in snap.children {
                (child as! DataSnapshot).ref.queryOrdered(byChild: "ownerUid").queryEqual(toValue: self.user.uid).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                    if (snapshot.value.debugDescription != "Optional(<null>)") {
                        for adm in snapshot.value as! NSDictionary {
                            let aux = adm.value as AnyObject
                            let admin = Admin()
                            if let hashKey = aux["hashKey"] {
                                if (hashKey != nil) {
                                    admin.hashKey = hashKey as! String
                                }
                            }
                            if let house_title = aux["house_title"] {
                                if house_title != nil {
                                    admin.house_title = house_title as! String
                                }
                            }
                            if let ownerUid = aux["ownerUid"] {
                                if (ownerUid != nil) {
                                    admin.ownerUid = ownerUid as! String
                                }
                            }
                            self.hashes.append(admin)
                            self.tableView.reloadData()
                        }
                    }
                })
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return houses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return houses[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! CustomViewCell
        cell.setupWithModel(model: hashes[indexPath.row])
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
            let selected = self.hashes[indexPath.row].house_title
            let selectedHash = self.hashes[indexPath.row].hashKey
            self.ref.child("admins").child(selectedHash).child(selected).removeValue() { (error, ref) -> Void in
                if (error != nil) {
                    Toast(msg: (error?.localizedDescription)!, view: self.view).showAlert()
                }
            }
        }
    }
}

extension AdminViewController: CustomViewCellDelegate {
    func didTappedButton(cell: CustomViewCell) {
        let hash = cell.hash_label.text
        UIPasteboard.general.string = hash
        Toast(msg: "HashKey copiada para área de transferência", view: self.view).showAlert()
    }
}
