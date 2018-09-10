//
//  HouseViewController.swift
//  Smart Home
//
//  Created by Gustavo Lidani on 10/09/2018.
//  Copyright © 2018 Gustavo Lidani. All rights reserved.
//

import UIKit

class HouseViewController: UITableViewController {

    var house: House!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = house.label
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
