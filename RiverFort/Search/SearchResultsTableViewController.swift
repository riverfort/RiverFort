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
        self.clearsSelectionOnViewWillAppear = false
        configureTableView()
    }
}

extension SearchResultsTableViewController {
    private func configureTableView() {
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 85.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    public func setFMPCompanies(fmpCompanies: [FMPStockTickerSearch]) {
        DispatchQueue.main.async {
            self.fmpCompanies = fmpCompanies
            self.tableView.reloadData()
        }
    }
}

extension SearchResultsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fmpCompanies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchResultCell
        cell.selectionStyle = .none
        let searchResult = fmpCompanies[indexPath.row]
        cell.set(fmpStockTickerSearch: searchResult)
        return cell
    }
}

extension SearchResultsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSymbol = fmpCompanies[indexPath.row].symbol
        searchCompany(ticker: selectedSymbol) { [self] (statusCode) in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    let companyDetailViewController = CompanyDetailViewController()
                    companyDetailViewController.company =
                        Company(company_ticker: fmpCompanies[indexPath.row].symbol, company_name: fmpCompanies[indexPath.row].name)
                    present(UINavigationController(rootViewController: companyDetailViewController), animated: true)
                } else {
                    print(statusCode)
                }
            }
        }
    }
}

extension SearchResultsTableViewController {
    private func searchCompany(ticker: String, completion: @escaping (Int) -> Void) {
        let api = "https://data.riverfort.com/api/v1/companies/\(ticker)"
        let url = URL(string: api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse!.statusCode)
        }
        task.resume()
    }
}
