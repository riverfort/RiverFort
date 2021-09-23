//
//  PriceChartButtonCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class PriceChartButtonCardController: TransparentCardController {
    public var company: Company?
    private lazy var viewPriceChartTrendsButton = ButtonCardPartView(title: "Show More Price Data")
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PriceChartButtonCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension PriceChartButtonCardController {
    private func configView() {
        viewPriceChartTrendsButton.delegate = self
        configCardParts()
    }
}

extension PriceChartButtonCardController {
    private func configCardParts() {
        setupCardParts([viewPriceChartTrendsButton])
    }
}

extension PriceChartButtonCardController: ButtonCardPartViewDelegate {
    func buttonDidTap() {
        print("buttonDidTap")
    }
}

extension PriceChartButtonCardController {
    private func createObserver() { }
    
    @objc private func didReceiveHistoricalPrice(notification: Notification) {
        guard let historicalPrice = notification.object as? [HistoricalPriceQuote] else { return }
    }
}
