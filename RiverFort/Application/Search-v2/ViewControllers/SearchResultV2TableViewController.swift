//
//  SearchResultV2TableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchResultV2TableViewController: UITableViewController {
    private var companies: [YahooFinanceSearchedCompany] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
}

extension SearchResultV2TableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if companies.count == 0 {
            return 0
        }
        return 60
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let symbolTitle = UILabel()
        configHeaderView(of: headerView, with: symbolTitle)
        return headerView
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
        return cell
    }
}

extension SearchResultV2TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        print(company.symbol)
    }
}

extension SearchResultV2TableViewController {
    private func configView() {
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    private func configHeaderView(of view: UIView, with label: UILabel) {
        view.addSubview(label)
        label.text = "Symbols"
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: systemMinimumLayoutMargins.leading).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
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
}
