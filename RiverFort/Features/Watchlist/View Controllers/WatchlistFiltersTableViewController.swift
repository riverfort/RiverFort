//
//  WatchlistFiltersTableViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/10/2021.
//

import UIKit
import RealmSwift

class WatchlistFiltersTableViewController: UITableViewController {
    public let realm = try! Realm()
    public lazy var watchlistCompanyList = realm.objects(WatchlistCompanyList.self).first

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
        let exchanges = watchlistCompanyList!.watchlistCompanies.map { $0.exchange }
        return exchanges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") }
        cell!.textLabel?.text = "Hello"
        return cell!
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
    private func configNavigationController() {
        navigationItem.title = "Filters"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done)
    }
    
    private func configTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
    }
}
