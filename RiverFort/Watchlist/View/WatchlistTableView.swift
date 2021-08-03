//
//  WatchlistTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import Foundation
import CoreData

class WatchlistTableView: UITableView {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var watchedCompanies      = [WatchedCompany]()
    private var watchedCompanyDetails = [CompanyDetail]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureAPI()
        getWatchedCompanies()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistTableView {
    private func configureTableView() {
        self.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate = self
        self.register(WatchlistTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension WatchlistTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchlistTableViewCell
        
        let watchedCompany = watchedCompanies[indexPath.row].company_ticker
        if let i = watchedCompanyDetails.firstIndex(where: { $0.company_ticker == watchedCompany}) {
            let watchedCompanyDetail = WatchedCompanyDetail(
                company_ticker: watchedCompanyDetails[i].company_ticker,
                company_name:   watchedCompanyDetails[i].company_name,
                currency:       watchedCompanyDetails[i].currency,
                close:          watchedCompanyDetails[i].close,
                change_percent: watchedCompanyDetails[i].change_percent,
                market_date:    watchedCompanyDetails[i].market_date)
            cell.setWatchlistTableViewCell(watchedCompanyDetail: watchedCompanyDetail)
        }
        return cell
    }
}

extension WatchlistTableView {
    private func getWatchedCompanies() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            watchedCompanies = try context.fetch(request)
            if watchedCompanies.count == 0 {
                for watchedCompany in watchedCompanies {
                    APIFunctions.functions.fetchCompanyDetail(companyTicker: watchedCompany.company_ticker!)
                }
            }
        } catch {
            print("error")
        }
    }
}

extension WatchlistTableView: CompanyDetailDataDelegate {
    private func configureAPI() {
        APIFunctions.functions.companyDetailDeleagate = self
    }
    
    func updateCompanyDetail(newCompanyDetail: String) {
        do {
            let companyDetail = try JSONDecoder().decode([CompanyDetail].self, from: newCompanyDetail.data(using: .utf8)!)
            watchedCompanyDetails.append(companyDetail[0])
        } catch {
            print("Failed to decode company detail!")
        }
    }
}
