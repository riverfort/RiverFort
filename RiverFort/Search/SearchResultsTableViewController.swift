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
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.estimatedRowHeight = 85.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fmpCompanies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchResultCell
        let searchResult = fmpCompanies[indexPath.row]
        cell.set(fmpStockTickerSearch: searchResult)
        return cell
    }
    
    public func setFMPCompanies(fmpCompanies: [FMPStockTickerSearch]) {
        DispatchQueue.main.async {
            self.fmpCompanies = fmpCompanies
            self.tableView.reloadData()
        }
    }
}
