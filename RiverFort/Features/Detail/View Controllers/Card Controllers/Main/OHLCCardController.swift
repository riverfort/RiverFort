//
//  OHLCCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import CardParts

class OHLCCardController: BaseCardController {
    private lazy var titlePart = CardPartTitleView(type: .titleOnly)
    
    private lazy var openLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var openDataPart = CardPartTitleView(type: .titleOnly)
    private lazy var openCardPartSV = CardPartStackView()
    
    private lazy var highLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var highDataPart = CardPartTitleView(type: .titleOnly)
    private lazy var highCardPartSV = CardPartStackView()
    
    private lazy var lowLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var lowDataPart = CardPartTitleView(type: .titleOnly)
    private lazy var lowCardPartSV = CardPartStackView()
    
    private lazy var closeLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var closeDataPart = CardPartTitleView(type: .titleOnly)
    private lazy var closeCardPartSV = CardPartStackView()
    
    private lazy var cardPartSV = CardPartStackView()
    
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

extension OHLCCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension OHLCCardController {
    private func configTitleView() {
        titlePart.title = "OHLC"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        openLabelPart.title = "O"
        openLabelPart.titleColor = .systemGray
        openLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        openLabelPart.label.adjustsFontForContentSizeCategory = true
        
        openDataPart.title = "-"
        openDataPart.titleColor = .label
        openDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        openDataPart.label.adjustsFontForContentSizeCategory = true
        
        openCardPartSV.axis = .horizontal
        openCardPartSV.distribution = .equalSpacing
        openCardPartSV.addArrangedSubview(openLabelPart)
        openCardPartSV.addArrangedSubview(openDataPart)
        
        highLabelPart.title = "H"
        highLabelPart.titleColor = .systemGray
        highLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        highLabelPart.label.adjustsFontForContentSizeCategory = true
        
        highDataPart.title = "-"
        highDataPart.titleColor = .label
        highDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        highDataPart.label.adjustsFontForContentSizeCategory = true
        
        highCardPartSV.axis = .horizontal
        highCardPartSV.distribution = .equalSpacing
        highCardPartSV.addArrangedSubview(highLabelPart)
        highCardPartSV.addArrangedSubview(highDataPart)
        
        lowLabelPart.title = "L"
        lowLabelPart.titleColor = .systemGray
        lowLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        lowLabelPart.label.adjustsFontForContentSizeCategory = true
        
        lowDataPart.title = "-"
        lowDataPart.titleColor = .label
        lowDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        lowDataPart.label.adjustsFontForContentSizeCategory = true
        
        lowCardPartSV.axis = .horizontal
        lowCardPartSV.distribution = .equalSpacing
        lowCardPartSV.addArrangedSubview(lowLabelPart)
        lowCardPartSV.addArrangedSubview(lowDataPart)
        
        closeLabelPart.title = "C"
        closeLabelPart.titleColor = .systemGray
        closeLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        closeLabelPart.label.adjustsFontForContentSizeCategory = true
        
        closeDataPart.title = "-"
        closeDataPart.titleColor = .label
        closeDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        closeDataPart.label.adjustsFontForContentSizeCategory = true
        
        closeCardPartSV.axis = .horizontal
        closeCardPartSV.distribution = .equalSpacing
        closeCardPartSV.addArrangedSubview(closeLabelPart)
        closeCardPartSV.addArrangedSubview(closeDataPart)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(openCardPartSV)
        cardPartSV.addArrangedSubview(highCardPartSV)
        cardPartSV.addArrangedSubview(lowCardPartSV)
        cardPartSV.addArrangedSubview(closeCardPartSV)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension OHLCCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: .receiveQuote, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let quote = notification.object as? Quote else { return }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        openDataPart.title = numberFormatter.string(from: NSNumber(value: quote.open))
        highDataPart.title = numberFormatter.string(from: NSNumber(value: quote.dayHigh))
        lowDataPart.title  = numberFormatter.string(from: NSNumber(value: quote.dayLow))
        closeDataPart.title = numberFormatter.string(from: NSNumber(value: quote.price))
    }
}
