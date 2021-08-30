//
//  SearchResultV2TableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchResultV2TableViewController: UITableViewController {
    private var companies: [YahooFinanceSearchedCompany] = []
    private var searchTerm: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
}

extension SearchResultV2TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}

extension SearchResultV2TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchV2ResultCell
        let company = companies[indexPath.row]
        cell.setCell(for: company)
        cell.setHighlight(for: searchTerm)
        return cell
    }
}

extension SearchResultV2TableViewController {
    private func configTableView() {
        tableView.register(SearchV2ResultCell.self, forCellReuseIdentifier: "cell")
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension SearchResultV2TableViewController {
    public func setCompanies(companies: [YahooFinanceSearchedCompany]) {
        self.companies = companies
    }
    
    public func setSearchTerm(_ searchTerm: String) {
        self.searchTerm = searchTerm
    }
}
