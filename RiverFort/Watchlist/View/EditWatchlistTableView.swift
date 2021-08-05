//
//  EditWatchlistTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit
import CoreData

class EditWatchlistTableView: UITableView {
    private var watchedCompanies = [WatchedCompany]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        getWatchedCompanies()
        configTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditWatchlistTableView {
    private func configTableView() {
        self.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate   = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension EditWatchlistTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text       = watchedCompanies[indexPath.row].company_ticker
        cell.detailTextLabel?.text = watchedCompanies[indexPath.row].company_name
        cell.textLabel?.font       = .preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
        cell.detailTextLabel?.textColor = .systemGray
        return cell
    }
}

extension EditWatchlistTableView {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            removeWatchedCompany(watchedCompany: watchedCompanies[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension EditWatchlistTableView {
    private func getWatchedCompanies() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            watchedCompanies = try PersistentContainer.context.fetch(request)
//            tableView.reloadData()
        } catch {
            print("error")
        }
    }
    
    private func removeWatchedCompany(watchedCompany: WatchedCompany) {
        PersistentContainer.context.delete(watchedCompany)
        do {
            try PersistentContainer.context.save()
            getWatchedCompanies()
        } catch {
            print("error")
        }
    }
}
