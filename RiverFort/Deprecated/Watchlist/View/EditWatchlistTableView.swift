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
        self.setEditing(true, animated: true)
        self.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate   = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configWatchedCompaniesAC(ac: UIAlertController) {
        ac.view.tintColor = .systemIndigo
        ac.addAction(UIAlertAction(title: "Clear Watchlist", style: .destructive, handler: { [self] _ in
            clearWatchedCompanies()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
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
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row > destinationIndexPath.row {
            watchedCompanies[sourceIndexPath.row].rowOrder = watchedCompanies[destinationIndexPath.row].rowOrder - 1
            for i in destinationIndexPath.row...watchedCompanies.count - 1 {
                watchedCompanies[i].rowOrder = watchedCompanies[i].rowOrder + 1
            }
        }
        if sourceIndexPath.row < destinationIndexPath.row + 1 {
            watchedCompanies[sourceIndexPath.row].rowOrder = watchedCompanies[destinationIndexPath.row].rowOrder + 1
            for i in 0...destinationIndexPath.row {
                watchedCompanies[i].rowOrder = watchedCompanies[i].rowOrder - 1
            }
        }
        do {
            try PersistentContainer.context.save()
            getWatchedCompanies()
        } catch {
            print("error")
        }
    }
}

extension EditWatchlistTableView {
    public func prepareClearWatchedCompanies() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        configWatchedCompaniesAC(ac: ac)
        UIApplication.topViewController()?.present(ac, animated: true)
    }
}

extension EditWatchlistTableView {
    private func getWatchedCompanies() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            watchedCompanies = try PersistentContainer.context.fetch(request)
        } catch {
            print("error")
        }
    }
    
    private func removeWatchedCompany(watchedCompany: WatchedCompany) {
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
        WatchlistSync.prepDeleteWatchlist(deviceToken: deviceToken!, companyTicker: watchedCompany.company_ticker!)
        PersistentContainer.context.delete(watchedCompany)
        do {
            try PersistentContainer.context.save()
            getWatchedCompanies()
        } catch {
            print("error")
        }
    }
        
    private func clearWatchedCompanies() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            watchedCompanies = try PersistentContainer.context.fetch(request)
            for watchedCompany in watchedCompanies {
                removeWatchedCompany(watchedCompany: watchedCompany)
            }
            getWatchedCompanies()
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        } catch {
            print("error")
        }
    }
}
