//
//  TableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit
import SPAlert

class SearchResultsTableViewController: UITableViewController {
    private var fmpCompanies: [FMPStockTickerSearch] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

extension SearchResultsTableViewController {
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
        let searchResult = fmpCompanies[indexPath.row]
        cell.set(fmpStockTickerSearch: searchResult)
        return cell
    }
}

extension SearchResultsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSymbol = fmpCompanies[indexPath.row].symbol
        let selectedName = fmpCompanies[indexPath.row].name
        searchCompany(ticker: selectedSymbol) { [self] (statusCode) in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    let companyDetailViewController = CompanyDetailViewController()
                    let navigationController = UINavigationController(rootViewController: companyDetailViewController)
                    companyDetailViewController.company = Company(company_ticker: selectedSymbol, company_name: selectedName)
                    present(navigationController, animated: true)
                } else {
                    let progressViewController = ProgressViewController()
                    configureProgressViewControllerModal(progressViewController: progressViewController)
                    present(progressViewController, animated: true)
                    APIFunctions
                        .functions
                        .addNewSymbol(
                            addOnSymbolRequest:
                                AddOnSymbolRequest(company_ticker: selectedSymbol, company_name: selectedName)) { (statusCode) in
                            if statusCode == 200 {
                                let companyDetailViewController = CompanyDetailViewController()
                                let navigationController = UINavigationController(rootViewController: companyDetailViewController)
                                companyDetailViewController.company = Company(company_ticker: selectedSymbol, company_name: selectedName)
                                progressViewController.dismiss(animated: true)
                                present(navigationController, animated: true)
                            } else {
                                progressViewController.dismiss(animated: true)
                                SPAlert.present(title: "Data Unavailable", preset: .error, haptic: .error)
                            }
                        }
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


extension SearchResultsTableViewController {
    private func configureTableView() {
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 85.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureProgressViewControllerModal(progressViewController: ProgressViewController) {
        progressViewController.modalTransitionStyle = .crossDissolve
        progressViewController.modalPresentationStyle = .fullScreen
    }
}
