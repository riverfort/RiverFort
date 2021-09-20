//
//  CompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import CardParts
import SPAlert

class CompanyDetailViewController: CardsViewController {
    public var company: Company?
    private lazy var add  = UIButton(type: .system)
    private lazy var more = UIButton(type: .system)
    private let cards = [HeaderCardController(),
                         TimeseriesCardController(),
                         PriceChartCardController(),
                         ProfileCardController(),
                         StatisticsCardController(),
                         OHLCCardController(),
                         ADTVCardController(),
                         ADTVStatisticsCardController(),
                         AADTVStatisticsCardController(),
                         NewsCardController()]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CompanyDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configView()
    }
}

extension CompanyDetailViewController {
    private func prepareView() {
        guard let company = company else { return }
        navigationItem.title = company.symbol
        getProfile(symbol: company.symbol)
        getQuote(symbol: company.symbol)
        getHistoricalPrice(symbol: company.symbol, exch: company.exchangeShortName)
    }
    
    private func configView() {
        collectionView.backgroundColor = .systemGroupedBackground
        configBarButtonItem()
        loadCards(cards: cards)
    }
    
    private func configBarButtonItem() {
        configAddButton()
        configMoreButton()
        configBarButtonStack()
    }
    
    private func configAddButton() {
        guard let symbol = navigationItem.title else { return }
        let isCompanyInWatchlist = WatchlistCoreDataManager.isWatchedCompany(company_ticker: symbol)
        if isCompanyInWatchlist { add.isHidden = true }
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)
        add.addTarget(self, action: #selector(didTapAddToWatchlist), for: .touchUpInside)
    }
    
    private func configMoreButton() {
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: Configuration.symbolConfiguration), for: .normal)
        more.showsMenuAsPrimaryAction = true
        var menu: UIMenu {
            return UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems)
        }
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Price & Vol",
                         image: UIImage(systemName: "chart.bar"),
                         state: UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) ? .off : .on,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(false, forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn)
                            more.menu = menu
                            NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
                         }),
                UIAction(title: "With News",
                         image: UIImage(systemName: "newspaper"),
                         state: UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) ? .on : .off,
                         handler: { [self] (_) in
                            UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn)
                            more.menu = menu
                            NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
                         }),
            ]
        }
        more.menu = menu
    }
    
    private func configBarButtonStack() {
        let barButtonStack = UIStackView.init(arrangedSubviews: [add, more])
        barButtonStack.distribution = .equalSpacing
        barButtonStack.axis = .horizontal
        barButtonStack.alignment = .center
        barButtonStack.spacing = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
    }
}

extension CompanyDetailViewController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueSelected), name: .chartValueSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chartValueNoLongerSelected), name: .chartValueNoLongerSelected, object: nil)
    }
    
    @objc private func chartValueSelected() { super.collectionView.isScrollEnabled = false }
    @objc private func chartValueNoLongerSelected() { super.collectionView.isScrollEnabled = true }
}

extension CompanyDetailViewController {
    private func getProfile(symbol: String) {
        getProfileFromFMP(symbol: symbol)
    }
    
    private func getQuote(symbol: String) {
        getQuoteFromYahooFinance(symbol: symbol)
    }

    private func getHistoricalPrice(symbol: String, exch: String) {
        getHistoricalPriceFromYahooFinance(symbol: symbol, exchange: exch)
    }
}

extension CompanyDetailViewController {
    @objc private func didTapAddToWatchlist() {
        guard let company = company else { return }
        guard !WatchlistCoreDataManager.isWatchedCompany(company_ticker: company.symbol) else { return }
        WatchlistCoreDataManager.addToWatchlist(company_ticker: company.symbol, company_name: company.name, exch: company.exchange)
        SPAlert.present(title: "Added to Watchlist", preset: .done, haptic: .success)
        add.isHidden = true
    }
}
