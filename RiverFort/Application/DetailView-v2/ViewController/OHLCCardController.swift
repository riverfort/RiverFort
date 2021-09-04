//
//  OHLCCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit
import CardParts

class OHLCCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    
    private let openLabelPart = CardPartTitleView(type: .titleOnly)
    private let openDataPart = CardPartTitleView(type: .titleOnly)
    private let openCardPartSV = CardPartStackView()
    
    private let highLabelPart = CardPartTitleView(type: .titleOnly)
    private let highDataPart = CardPartTitleView(type: .titleOnly)
    private let highCardPartSV = CardPartStackView()
    
    private let lowLabelPart = CardPartTitleView(type: .titleOnly)
    private let lowDataPart = CardPartTitleView(type: .titleOnly)
    private let lowCardPartSV = CardPartStackView()
    
    private let closeLabelPart = CardPartTitleView(type: .titleOnly)
    private let closeDataPart = CardPartTitleView(type: .titleOnly)
    private let closeCardPartSV = CardPartStackView()
    
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
        let aName = Notification.Name(NewSearchConstant.SELECT_SEARCH_COMPANY)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let company = notification.object as? YahooFinanceSearchedCompany else {
            return
        }
//        print(company)
    }
}
