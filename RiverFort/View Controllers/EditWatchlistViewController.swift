//
//  EditWatchlistViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 19/04/2021.
//

import UIKit
import CoreData

class EditWatchlistViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var watchedCompanies = [WatchedCompany]()
    public var editCompletion: (() -> Void)?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.setEditing(true, animated: true)
        tableView.register(EditWatchlistTableViewCell.self, forCellReuseIdentifier: Constants.EDITABLE_WATCHED_COMPANY_CELL_ID)
        return tableView
    }()


}


// MARK: - UIViewController

extension EditWatchlistViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initNavigationBar()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        editCompletion?()
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension EditWatchlistViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.EDITABLE_WATCHED_COMPANY_CELL_ID, for: indexPath)
        cell.textLabel?.text = watchedCompanies[indexPath.row].company_ticker 
        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = watchedCompanies[indexPath.row].company_name
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 12)
        cell.detailTextLabel?.textColor = .systemGray
        return cell
    }
}


// MARK: - UITableView Edit (Delete)

extension EditWatchlistViewController {
    
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


// MARK: - UITableView Edit (Move row)

extension EditWatchlistViewController {
    
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
            try context.save()
            getAllWatchedCompanies()
        } catch {
            print("Failed to reorder from core data")
        }
    }
}


// MARK: - NSFetchRequest (Retrieve data from persistent store)

extension EditWatchlistViewController {
    
    private func getAllWatchedCompanies() {
        do {
            let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
            let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
            request.sortDescriptors = [sort]
            watchedCompanies = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch watched company from core data")
        }
    }
    
    private func removeWatchedCompany(watchedCompany: WatchedCompany) {
        context.delete(watchedCompany)
        do {
            try context.save()
            getAllWatchedCompanies()
        } catch {
            print("Failed to delete the watched company from core data")
        }
    }
}


// MARK: - View configuration

extension EditWatchlistViewController {
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func initNavigationBar() {
        title = "Edit watchlist"
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clear", style: .plain, target: self, action: #selector(didTapRemoveAll))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(didTapCloseButton))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        getAllWatchedCompanies()
    }
}


// MARK: - navigationItem actions

extension EditWatchlistViewController {
    
    @objc private func didTapRemoveAll() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Clear All Watchlist", style: .destructive, handler: { (action) in
            for company in self.watchedCompanies {
                self.removeWatchedCompany(watchedCompany: company)
            }
            self.dismiss(animated: true, completion: nil)
        }))
        actionSheet.pruneNegativeWidthConstraints()
        present(actionSheet, animated: true)
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
}
