//
//  WatchlistTableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/09/2021.
//

import UIKit
import RealmSwift
import SPAlert

class WatchlistTableViewController: UITableViewController {
    private let realm = try! Realm()
    private lazy var watchlistCompanyList = realm.objects(WatchlistCompanyList.self).first

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        initWatchlistCompanyList()
        configNavigationController()
        configTableView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistCompanyList!.watchlistCompanies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") }
        cell!.textLabel?.text = watchlistCompanyList!.watchlistCompanies[indexPath.row].symbol
        cell!.detailTextLabel?.text = watchlistCompanyList!.watchlistCompanies[indexPath.row].name
        return cell!
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWatchlistCompany(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        rearrangeWatchlistCompanyList(from: fromIndexPath.row, to: to.row)
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchlistTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchlistCompnay = watchlistCompanyList!.watchlistCompanies[indexPath.row]
        let company = Company(symbol: watchlistCompnay.symbol, name: watchlistCompnay.name, exchange: watchlistCompnay.exchange, exchangeShortName: nil, type: nil)
        let companyDetailViewController = CompanyDetailViewController()
        companyDetailViewController.company = company
        navigationController?.pushViewController(companyDetailViewController, animated: true)
    }
}

extension WatchlistTableViewController {
    private func configNavigationController() {
        navigationItem.title = "Watchlist"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
    }
}

extension WatchlistTableViewController {
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSaveWatchlistCompany), name: .didSaveWatchlistCompany, object: nil)
    }
    
    @objc private func onDidSaveWatchlistCompany() { tableView.reloadData() }
}

extension WatchlistTableViewController {
    private func initWatchlistCompanyList() {
        if watchlistCompanyList == nil {
            do {
                try realm.write({
                    watchlistCompanyList = realm.create(WatchlistCompanyList.self, value: [])
                })
            } catch {
                print(error.localizedDescription)
                SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
            }
        }
    }
    
    private func deleteWatchlistCompany(row: Int) {
        let watchlistCompany = watchlistCompanyList!.watchlistCompanies[row]
        do {
            try realm.write({ realm.delete(watchlistCompany) })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
    
    private func rearrangeWatchlistCompanyList(from: Int, to: Int) {
        do {
            try realm.write({
                watchlistCompanyList!.watchlistCompanies.move(from: from, to: to)
            })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
}
