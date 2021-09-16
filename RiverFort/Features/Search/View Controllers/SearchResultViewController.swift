//
//  SearchResultViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import UIKit

class SearchResultViewController: UITableViewController {
    private lazy var companies: [YahooFinanceSearchedCompany] = []
}

extension SearchResultViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
}

extension SearchResultViewController {
    private func configTableHeaderView(of view: UIView, with label: UILabel) {
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

extension SearchResultViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if companies.count == 0 { return 0 }
        return 60
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let symbolTitle = UILabel()
        configTableHeaderView(of: headerView, with: symbolTitle)
        return headerView
    }
}

extension SearchResultViewController {
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
}

extension SearchResultViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return companies.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchResultCell
        let company = companies[indexPath.row]
        cell.setCell(for: company)
        return cell
    }
}

extension SearchResultViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCompany = companies[indexPath.row]
        let detailVC = CompanyDetailViewController()
        detailVC.company = NewCompany(symbol: selectedCompany.symbol, name: selectedCompany.name, exch: selectedCompany.exch)
        presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
        NotificationCenter.default.post(name: .selectCompanyFromSearchResult, object: selectedCompany)
    }
}

extension SearchResultViewController {
    public func setCompanies(companies: [YahooFinanceSearchedCompany]) {
        self.companies = companies
    }
}
