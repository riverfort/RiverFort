//
//  PriceChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class PriceChartCardController: BaseCardController {
    private lazy var priceChartPart = PriceChartCardPartView()
    private lazy var newsViewModel = NewsViewModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
        subscribeNewsViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PriceChartCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([priceChartPart])
    }
}

extension PriceChartCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartTimeseries), name: .timeseriesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDateForNews), name: .receiveYahooFinanceQuoteResult, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDataForHistPrice), name: .receiveYahooFinanceHistoricalPrice, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preparePriceChartDisplayModeChanged), name: .priceChartDisplayModeUpdated, object: nil)
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        priceChartPart.changeTimeseries(for: UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex))
    }
    
    @objc private func prepareChartDateForNews(notification: Notification) {
        guard UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) == true else { return }
        guard let yahooFinanceQuoteResult = notification.object as? YahooFinanceQuoteResult else { return }
        let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result[0].quote
        let market = yahooFinanceQuote.market
        switch market {
        case "gb_market":
            newsViewModel.fetchRSSFeedsUK(symbol: yahooFinanceQuote.symbol, timeseries: 30)
        default:
            return
        }
    }
    
    @objc private func prepareChartDataForHistPrice(notification: Notification) {
        guard let histPrice = notification.object as? [HistPrice] else { return }
        priceChartPart.setChartData(with: histPrice)
    }
    
    @objc private func preparePriceChartDisplayModeChanged() {
        print(UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn))
    }
}

extension PriceChartCardController {
    private func subscribeNewsViewModel() {
        guard UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) == true else { return }
        newsViewModel.rssItemsForNews.asObservable().subscribe(
            onNext: { [self] in
                priceChartPart.setChartDataForNews(with: $0)
            }
        ).disposed(by: bag)
    }
}
