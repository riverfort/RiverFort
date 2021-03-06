//
//  HeaderCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 01/09/2021.
//

import CardParts

class HeaderCardController: BaseCardController {
    public var company: Company?
    private lazy var namePart = CardPartTitleView(type: .titleOnly)
    private lazy var exchPart = CardPartTitleView(type: .titleOnly)
    private lazy var pricePart  = CardPartTitleView(type: .titleOnly)
    private lazy var changePart = CardPartTitleView(type: .titleOnly)
    
    private lazy var cardPartSV1 = CardPartStackView()
    private lazy var cardPartSV2 = CardPartStackView()
    
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

extension HeaderCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
        prepareNameAndExch()
    }
}

extension HeaderCardController {
    private func configTitleView() {
        namePart.label.numberOfLines = 0
        namePart.label.textAlignment = .left
        namePart.titleColor = .label
        namePart.titleFont = .preferredFont(forTextStyle: .headline)
        namePart.label.adjustsFontForContentSizeCategory = true
        
        exchPart.label.textAlignment = .right
        exchPart.titleColor = .systemGray
        exchPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        exchPart.label.adjustsFontForContentSizeCategory = true
        
        pricePart.title = "-"
        pricePart.titleColor = .label
        pricePart.titleFont = .preferredFont(forTextStyle: .headline)
        pricePart.label.adjustsFontForContentSizeCategory = true
        
        changePart.title = "-"
        changePart.titleColor = .label
        changePart.titleFont = .preferredFont(forTextStyle: .headline)
        changePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configStackView() {
        cardPartSV1.axis = .horizontal
        cardPartSV1.distribution = .fillEqually
        cardPartSV1.addArrangedSubview(namePart)
        cardPartSV1.addArrangedSubview(exchPart)
        
        cardPartSV2.spacing = 5
        cardPartSV2.axis = .vertical
        cardPartSV2.distribution = .equalSpacing
        cardPartSV2.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV2.addArrangedSubview(cardPartSV1)
        cardPartSV2.addArrangedSubview(pricePart)
        cardPartSV2.addArrangedSubview(changePart)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV2])
    }
}

extension HeaderCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(preparePrice), name: .didReceiveQuote, object: nil)
    }
    
    private func prepareNameAndExch() {
        guard let company = company else { return }
        namePart.title = company.name
        exchPart.title = "\(company.exchange)"
    }
    
    @objc private func preparePrice(notification: Notification) {
        guard let quote = notification.object as? Quote else { return }
        let changeDisp = String(format: "%.2f", quote.change)
        let changePercentDisp = String(format: "%.2f", quote.changePercent)
        switch quote.change {
        case let change where change > 0:
            changePart.titleColor = .systemGreen
            changePart.title = "+\(changeDisp)(+\(changePercentDisp)%)"
        case let change where change < 0:
            changePart.titleColor = .systemRed
            changePart.title = "\(changeDisp)(\(changePercentDisp)%)"
        default:
            changePart.titleColor = .label
            changePart.title = "\(changeDisp)(\(changePercentDisp)%)"
        }
        if let currency = quote.currency { pricePart.title = "\(currency) \(quote.price)" }
        else { pricePart.title = "\(quote.price)" }
    }
}
