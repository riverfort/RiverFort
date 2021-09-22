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
    private lazy var header = HeaderCardController()
    private lazy var timeseries = TimeseriesCardController()
    private lazy var priceChart = PriceChartCardController()
    private lazy var profile = ProfileCardController()
    private lazy var statistics = StatisticsCardController()
    private lazy var ohlc = OHLCCardController()
    private lazy var adtvStatistics = ADTVStatisticsCardController()
    private lazy var adtvButton = ADTVButtonCardController()
    private lazy var news = NewsCardController()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeseries.setSelectedSegmentIndex()
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
        configCards()
    }

    private func configBarButtonItem() {
        configAddButton()
        configMoreButton()
        configBarButtonStack()
    }
    
    private func configCards() {
        let cards = [header, timeseries, priceChart, profile, statistics, ohlc, adtvStatistics, adtvButton, news]
        header.company = company
        priceChart.company = company
        adtvStatistics.company = company
        adtvButton.company = company
        loadCards(cards: cards)
    }
}

extension CompanyDetailViewController {
    private func configAddButton() {
        guard let symbol = navigationItem.title else { return }
        let isCompanyInWatchlist = WatchlistCoreDataManager.isWatchedCompany(company_ticker: symbol)
        if isCompanyInWatchlist { add.isHidden = true }
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
        add.addTarget(self, action: #selector(didTapAddToWatchlist), for: .touchUpInside)
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

extension CompanyDetailViewController {
    private func configMoreButton() {
        let defaults = UserDefaults.standard
        let key = UserDefaults.Keys.isPriceChartNewsDisplayModeOn
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
        more.showsMenuAsPrimaryAction = true
        var menu: UIMenu { UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems) }
        var menuItems: [UIAction] { [
            UIAction(title: "Price & Vol",
                     image: UIImage(systemName: "chart.bar"),
                     state: defaults.bool(forKey: key) ? .off : .on,
                     handler: { [self] (_) in
                        defaults.setValue(false, forKey: key)
                        more.menu = menu
                        NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
                     }),
            UIAction(title: "With News",
                     image: UIImage(systemName: "newspaper"),
                     state: defaults.bool(forKey: key) ? .on : .off,
                     handler: { [self] (_) in
                        defaults.setValue(true, forKey: key)
                        more.menu = menu
                        NotificationCenter.default.post(name: .priceChartDisplayModeUpdated, object: nil)
                     }),
        ]}
        more.menu = menu
    }
}
