//
//  NewSearchViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 22/07/2021.
//

import UIKit

class NewSearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureSearchController()
    }
}

extension NewSearchViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Search"
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Symbols, Companies"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

extension NewSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
