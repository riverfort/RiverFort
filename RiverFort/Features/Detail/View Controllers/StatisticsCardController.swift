//
//  StatisticsCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import CardParts

class StatisticsCardController: BaseCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let mktCapLabelPart = CardPartTitleView(type: .titleOnly)
    private let mktCapDataPart = CardPartTitleView(type: .titleOnly)
    private let mktCapCardPartSV = CardPartStackView()
    
    private let volLabelPart = CardPartTitleView(type: .titleOnly)
    private let volDataPart = CardPartTitleView(type: .titleOnly)
    private let volCardPartSV = CardPartStackView()
    
    private let cardPartSV = CardPartStackView()
    
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

extension StatisticsCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension StatisticsCardController {
    private func configTitleView() {
        titlePart.title = "Statistics"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        mktCapLabelPart.title = "Mkt Cap"
        mktCapLabelPart.titleColor = .systemGray
        mktCapLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        mktCapLabelPart.label.adjustsFontForContentSizeCategory = true
        
        mktCapDataPart.title = "-"
        mktCapDataPart.titleColor = .label
        mktCapDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        mktCapDataPart.label.adjustsFontForContentSizeCategory = true
        
        mktCapCardPartSV.axis = .horizontal
        mktCapCardPartSV.distribution = .equalSpacing
        mktCapCardPartSV.addArrangedSubview(mktCapLabelPart)
        mktCapCardPartSV.addArrangedSubview(mktCapDataPart)
        
        volLabelPart.title = "Vol"
        volLabelPart.titleColor = .systemGray
        volLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        volLabelPart.label.adjustsFontForContentSizeCategory = true
        
        volDataPart.title = "-"
        volDataPart.titleColor = .label
        volDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        volDataPart.label.adjustsFontForContentSizeCategory = true
        
        volCardPartSV.axis = .horizontal
        volCardPartSV.distribution = .equalSpacing
        volCardPartSV.addArrangedSubview(volLabelPart)
        volCardPartSV.addArrangedSubview(volDataPart)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(mktCapCardPartSV)
        cardPartSV.addArrangedSubview(volCardPartSV)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension StatisticsCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: .receiveYahooFinanceQuoteResult, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let yahooFinanceQuoteResult = notification.object as? YahooFinanceQuoteResult else { return }
        let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result[0].quote
        if let mktCap = yahooFinanceQuote.marketCap {
            mktCapDataPart.title = NumberShortScale.formatNumber(mktCap)
        }
        volDataPart.title = NumberShortScale.formatNumber(Double(yahooFinanceQuote.regularMarketVolume))
    }
}
