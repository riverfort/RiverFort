//
//  PriceChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class PriceChartCardController: BaseCardController {
    public var company: Company?
    private let defaults = UserDefaults.standard
    private lazy var priceChartPart = PriceChartCardPartView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PriceChartCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([priceChartPart])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension PriceChartCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(onChartModeUpdated), name: .hasUpdatedChartMode, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeseriesUpdated), name: .hasUpdatedTimeSeries, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveHistoricalPrice), name: .didReceiveHistoricalPrice, object: nil)
    }
    
    @objc private func onChartModeUpdated() {
        print("News chart mode: \(defaults.bool(forKey: UserDefaults.Keys.isNewsChartOn))")
    }
    
    @objc private func onTimeseriesUpdated(notification: Notification) {
        priceChartPart.changeTimeseries(for: defaults.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex))
    }
    
    @objc private func onDidReceiveHistoricalPrice(notification: Notification) {
        guard let historicalPrice = notification.object as? [HistoricalPriceQuote] else { return }
        priceChartPart.setChartDataForPrice(historicalPrice: historicalPrice)
    }
}
