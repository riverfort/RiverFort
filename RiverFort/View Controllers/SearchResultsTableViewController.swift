//
//  TableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    private var fmpCompanies: [FMPStockTickerSearch] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fmpCompanies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = fmpCompanies[indexPath.row].symbol
        cell.detailTextLabel?.text = fmpCompanies[indexPath.row].name
        return cell
    }
    
    public func setFMPCompanies(fmpCompanies: [FMPStockTickerSearch]) {
        self.fmpCompanies = fmpCompanies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
