//
//  SearchResultTableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    private var companies: [YahooFinanceSearchedCompany] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
}

extension SearchResultTableViewController {
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

extension SearchResultTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}

extension SearchResultTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchResultCell
        let company = companies[indexPath.row]
        cell.setCell(for: company)
        return cell
    }
}

extension SearchResultTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCompany = companies[indexPath.row]
        let detailVC = NewCompanyDetailViewController()
        detailVC.company = NewCompany(symbol: selectedCompany.symbol, name: selectedCompany.name, exch: selectedCompany.exch)
        presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
        let aName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.post(name: aName, object: selectedCompany)
    }
}

extension SearchResultTableViewController {
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
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "cell")
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension SearchResultTableViewController {
    public func setCompanies(companies: [YahooFinanceSearchedCompany]) {
        self.companies = companies
    }
}
