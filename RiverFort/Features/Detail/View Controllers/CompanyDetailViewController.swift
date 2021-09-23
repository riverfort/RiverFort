//
//  CompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import CardParts

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
        getHistoricalPrice(symbol: company.symbol)
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
        add.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
    }
    
    private func configMoreButton() {
        more.showsMenuAsPrimaryAction = true
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
        configMoreButtonMenu()
    }
    
    private func configBarButtonStack() {
        let barButtonStack = UIStackView.init(arrangedSubviews: [add, more])
        barButtonStack.distribution = .equalSpacing
        barButtonStack.axis = .horizontal
        barButtonStack.alignment = .center
        barButtonStack.spacing = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
    }
    
    private func configMoreButtonMenu() {
        let defaults = UserDefaults.standard, key = UserDefaults.Keys.isPriceChartNewsDisplayModeOn
        var menu: UIMenu { UIMenu(title: "Share Price Chart", image: nil, identifier: nil, options: [], children: menuItems) }
        var menuItems: [UIAction] { [
            UIAction(title: "Price & Volume",
                     image: UIImage(systemName: "waveform.path.ecg.rectangle"),
                     state: defaults.bool(forKey: key) ? .off : .on,
                     handler: { [unowned self] (_) in
                        defaults.setValue(false, forKey: key)
                        NotificationCenter.default.post(name: .didUpdatePriceChartDisplayMode, object: nil)
                        more.menu = menu
                     }),
            UIAction(title: "Plus News",
                     image: UIImage(systemName: "circlebadge.fill"),
                     state: defaults.bool(forKey: key) ? .on : .off,
                     handler: { [unowned self] (_) in
                        defaults.setValue(true, forKey: key)
                        NotificationCenter.default.post(name: .didUpdatePriceChartDisplayMode, object: nil)
                        more.menu = menu
                     }),
        ]}
        more.menu = menu
    }
}

extension CompanyDetailViewController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSelectChartValue), name: .didSelectChartValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidNoLongerSelectChartValue), name: .didNoLongerSelectChartValue, object: nil)
    }
    
    @objc private func onDidSelectChartValue() { super.collectionView.isScrollEnabled = false }
    @objc private func onDidNoLongerSelectChartValue() { super.collectionView.isScrollEnabled = true }
}

extension CompanyDetailViewController {
    private func getProfile(symbol: String) { getProfileFromFMP(symbol: symbol) }
    private func getQuote(symbol: String) { getQuoteFromYahooFinance(symbol: symbol) }
    private func getHistoricalPrice(symbol: String) { getHistoricalPriceFromYahooFinance(symbol: symbol) }
}
