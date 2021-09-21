//
//  ADTVStatisticsCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts

class ADTVStatisticsCardController: BaseCardController {
    private lazy var titlePart = CardPartTitleView(type: .titleOnly)

    private lazy var adtv1LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv1DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv1CardPartSV = CardPartStackView()
    
    private lazy var adtv5LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv5DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv5CardPartSV = CardPartStackView()
    
    private lazy var adtv10LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv10DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv10CardPartSV = CardPartStackView()
    
    private lazy var adtv20LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv20DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv20CardPartSV = CardPartStackView()
    
    private lazy var adtv60LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv60DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv60CardPartSV = CardPartStackView()
    
    private lazy var adtv120LabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv120DataPart = CardPartTitleView(type: .titleOnly)
    private lazy var adtv120CardPartSV = CardPartStackView()
    
    private lazy var cardPartSV = CardPartStackView()
    
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

extension ADTVStatisticsCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension ADTVStatisticsCardController {
    private func configTitleView() {
        titlePart.title = "ADTV"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        adtv1LabelPart.title = "1"
        adtv1LabelPart.titleColor = .systemGray
        adtv1LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv1LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv1DataPart.title = "-"
        adtv1DataPart.titleColor = .label
        adtv1DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv1DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv1CardPartSV.axis = .horizontal
        adtv1CardPartSV.distribution = .equalSpacing
        adtv1CardPartSV.addArrangedSubview(adtv1LabelPart)
        adtv1CardPartSV.addArrangedSubview(adtv1DataPart)
        
        adtv5LabelPart.title = "5"
        adtv5LabelPart.titleColor = .systemGray
        adtv5LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv5LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv5DataPart.title = "-"
        adtv5DataPart.titleColor = .label
        adtv5DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv5DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv5CardPartSV.axis = .horizontal
        adtv5CardPartSV.distribution = .equalSpacing
        adtv5CardPartSV.addArrangedSubview(adtv5LabelPart)
        adtv5CardPartSV.addArrangedSubview(adtv5DataPart)
        
        adtv10LabelPart.title = "10"
        adtv10LabelPart.titleColor = .systemGray
        adtv10LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv10LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv10DataPart.title = "-"
        adtv10DataPart.titleColor = .label
        adtv10DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv10DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv10CardPartSV.axis = .horizontal
        adtv10CardPartSV.distribution = .equalSpacing
        adtv10CardPartSV.addArrangedSubview(adtv10LabelPart)
        adtv10CardPartSV.addArrangedSubview(adtv10DataPart)
        
        adtv20LabelPart.title = "20"
        adtv20LabelPart.titleColor = .systemGray
        adtv20LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv20LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv20DataPart.title = "-"
        adtv20DataPart.titleColor = .label
        adtv20DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv20DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv20CardPartSV.axis = .horizontal
        adtv20CardPartSV.distribution = .equalSpacing
        adtv20CardPartSV.addArrangedSubview(adtv20LabelPart)
        adtv20CardPartSV.addArrangedSubview(adtv20DataPart)
        
        adtv60LabelPart.title = "60"
        adtv60LabelPart.titleColor = .systemGray
        adtv60LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv60LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv60DataPart.title = "-"
        adtv60DataPart.titleColor = .label
        adtv60DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv60DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv60CardPartSV.axis = .horizontal
        adtv60CardPartSV.distribution = .equalSpacing
        adtv60CardPartSV.addArrangedSubview(adtv60LabelPart)
        adtv60CardPartSV.addArrangedSubview(adtv60DataPart)
        
        adtv120LabelPart.title = "120"
        adtv120LabelPart.titleColor = .systemGray
        adtv120LabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv120LabelPart.label.adjustsFontForContentSizeCategory = true
        
        adtv120DataPart.title = "-"
        adtv120DataPart.titleColor = .label
        adtv120DataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        adtv120DataPart.label.adjustsFontForContentSizeCategory = true
        
        adtv120CardPartSV.axis = .horizontal
        adtv120CardPartSV.distribution = .equalSpacing
        adtv120CardPartSV.addArrangedSubview(adtv120LabelPart)
        adtv120CardPartSV.addArrangedSubview(adtv120DataPart)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(adtv1CardPartSV)
        cardPartSV.addArrangedSubview(adtv5CardPartSV)
        cardPartSV.addArrangedSubview(adtv10CardPartSV)
        cardPartSV.addArrangedSubview(adtv20CardPartSV)
        cardPartSV.addArrangedSubview(adtv60CardPartSV)
        cardPartSV.addArrangedSubview(adtv120CardPartSV)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension ADTVStatisticsCardController {
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveHistoricalPrice), name: .receiveHistoricalPrice, object: nil)
    }
    
    @objc private func didReceiveHistoricalPrice(notification: Notification) {
        guard let historicalPrice = notification.object as? [HistoricalPriceQuote] else { return }
        print(historicalPrice)
    }
}
