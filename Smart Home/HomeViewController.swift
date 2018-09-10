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
        
        toolbar.setLeftBarButtonItems([
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openModal(_:)))
        ], animated: true)

        user = Auth.auth().currentUser!;
        ref = Database.database().reference()
        self.retrieveHouses()
    }
    
    func retrieveHouses() -> Void {
        ref.child("houses").child(self.user.uid).observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            self.houses = []
            let houseDict = snapshot.value as? NSDictionary
            
            for house in houseDict! {
                let aux = (house.value as AnyObject)
                let house = House()
                if let components = aux["components"] {
                    house.components = components as! NSArray
                }
                if let title = aux["title"] {
                    house.label = title as! String
                }
                self.houses.append(house)
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func openModal(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "UIAlertController", message: "Adicionar Casa", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Nome da casa"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: UIAlertActionStyle.default,
            handler: { (UIAlertAction) -> Void in
                let houseName = alert.textFields![0].text!
                self.ref.child("houses").child(self.user.uid).child(houseName).setValue(["title": houseName]);
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToHouseView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let houseViewController = segue.destination as! HouseViewController
                houseViewController.house = self.houses[indexPath.row]
            }
        }
    }

}
