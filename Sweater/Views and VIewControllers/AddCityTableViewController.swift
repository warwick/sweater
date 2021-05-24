//
//  AddCityTableViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit

class AddCityTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change to: \(searchText)")
    }

}
