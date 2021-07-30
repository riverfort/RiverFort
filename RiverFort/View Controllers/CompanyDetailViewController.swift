//
//  CompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/05/2021.
//

import UIKit
import CoreData
import CardParts
import SPAlert

import RxSwift


class CompanyDetailViewController: CardsViewController {
    
    public  var company: Company?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var watchedCompanies = [WatchedCompany]()
    private var symbol = ""
    private var feedsViewModel = FeedsViewModel()
    private final class AddToWatchlistUIBarButtonItem: UIBarButtonItem {
        var company_ticker: String?
        var company_name: String?
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        if UIDevice.current.orientation.isLandscape {
            self.cardCellMargins = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        } else {
            self.cardCellMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        HapticsManager.shared.impact(style: .soft)
        
        guard company != nil else {
            return
        }

        navigationItem.title = company!.company_ticker
        
        self.symbol = company!.company_ticker
        if Regex.lse_regex.matches(company!.company_ticker) {
            self.symbol.removingRegexMatches(pattern: "\\.L")
            self.feedsViewModel = FeedsViewModel(symbol: self.symbol)
        } else {
            self.feedsViewModel = FeedsViewModel()
        }
        
        let addToWatchListButton = AddToWatchlistUIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .done,
            target: self,
            action: #selector(didTapAdd(sender:)))
        addToWatchListButton.company_ticker = company!.company_ticker
        addToWatchListButton.company_name   = company!.company_name
        if !isWatchedCompany(company_ticker: company!.company_ticker) {
            navigationItem.rightBarButtonItem = addToWatchListButton
        }

        let cards: [CardPartsViewController] = [
            ThemedCardController(quotes: CardPartQuotesView(company: company!), demoChart: CardPartPriceChartView(company: company!, feedsViewModel: self.feedsViewModel)),
            ThemedCardController(adtvChart: ADTVChartView(company: company!)),
            ProfileCardController(title: "Profile", company: company!),
            QuotesCardController(company: company!),
            ADTVCardController(company: company!),
            FeedsCardController(feedsViewModel: self.feedsViewModel),
        ]

        loadCards(cards: cards)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chartInteracting(notification:)), name: Notification.Name("Interacting"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chartEndInteracting(notification:)), name: Notification.Name("EndInteracting"), object: nil)
    }
    
    @objc func chartInteracting(notification: Notification) {
        super.collectionView.isScrollEnabled = false
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = false
        }
    }
    
    @objc func chartEndInteracting(notification: Notification) {
        super.collectionView.isScrollEnabled = true
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        }
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        super.collectionView.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.cardCellMargins = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            super.viewWillTransition(to: size, with: coordinator)
        } else {
            self.cardCellMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            super.viewWillTransition(to: size, with: coordinator)
        }
    }
}

// MARK: - Watchlist
extension CompanyDetailViewController {
    private func isWatchedCompany(company_ticker: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchedCompany")
        fetchRequest.predicate = NSPredicate(format: "company_ticker = %@", company_ticker)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    @objc private func didTapAdd(sender: AddToWatchlistUIBarButtonItem) {
        if isWatchedCompany(company_ticker: sender.company_ticker!) {
            SPAlert.present(title: "Added to Watchlist", preset: .done, haptic: .success)
        } else {
            self.saveToWatchlist(company_ticker: sender.company_ticker!, company_name: sender.company_name!)
            SPAlert.present(title: "Added to Watchlist", preset: .done, haptic: .success)
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func getWatchedCompanies() {
        let request = WatchedCompany.fetchRequest() as NSFetchRequest<WatchedCompany>
        let sort = NSSortDescriptor(key: "rowOrder", ascending: true)
        request.sortDescriptors = [sort]
        do {
            watchedCompanies = try context.fetch(request)
        } catch {
            print("Failed to fetch watched company from core data")
        }
    }
            
    func saveToWatchlist(company_ticker: String, company_name: String) {
        getWatchedCompanies()
        let watchedCompany = WatchedCompany(context: context)
        watchedCompany.company_ticker = company_ticker
        watchedCompany.company_name   = company_name
        watchedCompany.addedAt        = Date()
        watchedCompany.rowOrder       = (watchedCompanies.last?.rowOrder ?? 0) + 1
        do {
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("addedToWatchlist"), object: nil)
        } catch {
            print("Failed to add watched company to core data")
        }
    }
}
