//
//  WatchlistFiltersTableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/10/2021.
//

import UIKit
import RealmSwift

struct FilteringExchange {
    let name: String
    let isFiltered: Bool
}

class WatchlistFiltersTableViewController: UITableViewController {
    public let realm = try! Realm()
    public lazy var exchanges = Array(Set(realm.objects(WatchlistCompanyList.self).first!.watchlistCompanies.map { $0.exchange })).sorted { $0 < $1 }
    public lazy var filteringExchanges = exchanges.map { FilteringExchange(name: $0, isFiltered: false) }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return filteringExchanges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let filteringExchange = filteringExchanges[indexPath.row]
        cell.textLabel?.text = filteringExchange.name
        if filteringExchange.isFiltered { cell.accessoryType = .checkmark }
        else { cell.accessoryType = .none }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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

extension WatchlistFiltersTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Include exchanges"
        default: return ""
        }
    }
}

extension WatchlistFiltersTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let filteringExchange = filteringExchanges[indexPath.row]
        let newFilteringExchange = FilteringExchange(name: filteringExchange.name, isFiltered: !filteringExchange.isFiltered)
        filteringExchanges.remove(at: indexPath.row)
        filteringExchanges.insert(newFilteringExchange, at: indexPath.row)
        if newFilteringExchange.isFiltered { cell.accessoryType = .checkmark }
        else { cell.accessoryType = .none }
    }
}

extension WatchlistFiltersTableViewController {
    private func configNavigationController() {
        navigationItem.title = "Filters"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
    }
    
    private func configTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tintColor = .systemIndigo
    }
}

extension WatchlistFiltersTableViewController {
    @objc private func didTapDone() { dismiss(animated: true) }
}
