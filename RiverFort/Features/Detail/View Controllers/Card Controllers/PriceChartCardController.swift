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
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDataForNews), name: .receiveQuote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartDataForHistPrice), name: .receiveHistoricalPrice, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preparePriceChartDisplayModeChanged), name: .priceChartDisplayModeUpdated, object: nil)
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        priceChartPart.changeTimeseries(for: UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex))
    }
    
    @objc private func prepareChartDataForNews(notification: Notification) {
        guard UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) == true else { return }
        guard let quote = notification.object as? Quote else { return }
        let market = quote.market
        switch market {
        case "gb_market":
            subscribeNewsViewModel()
            newsViewModel.fetchRSSFeedsUK(symbol: quote.symbol, timeseries: 30)
        default:
            return
        }
    }
    
    @objc private func prepareChartDataForHistPrice(notification: Notification) {
        guard let histPrice = notification.object as? [HistoricalPriceQuote] else { return }
        priceChartPart.setChartData(with: histPrice)
    }
    
    @objc private func preparePriceChartDisplayModeChanged() {
        print(UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn))
    }
}

extension PriceChartCardController {
    private func subscribeNewsViewModel() {
        guard UserDefaults.standard.bool(forKey: UserDefaults.Keys.isPriceChartNewsDisplayModeOn) == true else { return }
//        newsViewModel.rssItemsForNews.asObservable().subscribe(
//            onNext: { [self] in
//                priceChartPart.setChartDataForNews(with: $0)
//            }
//        ).disposed(by: bag)
    }
}
