//
//  CompanyDetailViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 31/08/2021.
//

import CardParts
import RealmSwift
import SPAlert

class CompanyDetailViewController: CardsViewController {
    public var company: Company?
    private let realm = try! Realm()
    private lazy var watchlistCompanyList = realm.objects(WatchlistCompanyList.self).first
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
        guard let isCompanyInWatchlist = isCompanyInWatchlist() else { return }
        if isCompanyInWatchlist {
            add.isHidden = true
        } else {
            add.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
            add.addTarget(self, action: #selector(saveWatchlistCompany), for: .touchUpInside)
        }
    }
    
    private func configMoreButton() {
        more.showsMenuAsPrimaryAction = true
        more.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.Configuration.semibold), for: .normal)
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

extension CompanyDetailViewController {
    private func isCompanyInWatchlist() -> Bool? {
        guard let company = company else { return nil }
        let watchlistCompany = realm.object(ofType: WatchlistCompany.self, forPrimaryKey: company.symbol)
        if watchlistCompany == nil { return false }
        else { return true }
    }
    
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
    
    @objc private func saveWatchlistCompany() {
        guard let company = company else { return }
        initWatchlistCompanyList()
        let watchlistCompany = WatchlistCompany()
        watchlistCompany.symbol = company.symbol
        watchlistCompany.name = company.name
        watchlistCompany.exchange = company.exchange
        do {
            try realm.write({
                realm.add(watchlistCompany, update: .modified)
                watchlistCompanyList!.watchlistCompanies.append(watchlistCompany)
            })
            add.isHidden = true
            SPAlert.present(title: "Added to watchlist", preset: .done, haptic: .success)
            NotificationCenter.default.post(name: .didSaveWatchlistCompany, object: nil)
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
}
