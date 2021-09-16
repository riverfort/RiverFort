//
//  ProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/09/2021.
//

import CardParts
import SafariServices

class ProfileCardController: BaseCardController {
    private lazy var titlePart = CardPartTitleView(type: .titleOnly)
    
    private lazy var industryLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var industryDataPart = CardPartTitleView(type: .titleOnly)

    private lazy var sectorLabelPart = CardPartTitleView(type: .titleOnly)
    private lazy var sectorDataPart = CardPartTitleView(type: .titleOnly)
    
    private lazy var readMoreButtonPart = CardPartButtonView()
    private lazy var readMoreURL = URL(string: "")
    
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

extension ProfileCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension ProfileCardController {
    private func configTitleView() {
        titlePart.title = "Profie"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
        
        industryLabelPart.title = "Industry"
        industryLabelPart.label.numberOfLines = 0
        industryLabelPart.titleColor = .systemGray
        industryLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        industryLabelPart.label.adjustsFontForContentSizeCategory = true
        
        industryDataPart.title = "-"
        industryDataPart.label.numberOfLines = 0
        industryDataPart.titleColor = .label
        industryDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        industryDataPart.label.adjustsFontForContentSizeCategory = true
        
        sectorLabelPart.title = "Sector"
        sectorLabelPart.label.numberOfLines = 0
        sectorLabelPart.titleColor = .systemGray
        sectorLabelPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        sectorLabelPart.label.adjustsFontForContentSizeCategory = true
        
        sectorDataPart.title = "-"
        sectorDataPart.label.numberOfLines = 0
        sectorDataPart.titleColor = .label
        sectorDataPart.titleFont = .preferredFont(forTextStyle: .subheadline)
        sectorDataPart.label.adjustsFontForContentSizeCategory = true
        
        readMoreButtonPart.setTitle("Read more", for: .normal)
        readMoreButtonPart.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        readMoreButtonPart.titleLabel?.adjustsFontForContentSizeCategory = true
        readMoreButtonPart.setTitleColor(.link, for: .normal)
        readMoreButtonPart.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
        cardPartSV.addArrangedSubview(industryLabelPart)
        cardPartSV.addArrangedSubview(industryDataPart)
        cardPartSV.addArrangedSubview(sectorLabelPart)
        cardPartSV.addArrangedSubview(sectorDataPart)
        cardPartSV.addArrangedSubview(readMoreButtonPart)
    }
    
    private func configCardParts() {
        configTitleView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension ProfileCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareReadMoreButton), name: .receiveQuote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: .receiveProfile, object: nil)
    }
    
    @objc private func prepareReadMoreButton(notification: Notification) {
        guard let quote = notification.object as? Quote else { return }
        let exchange = quote.exchange
        switch exchange {
        case "LSE":
            readMoreButtonPart.setTitle("Read more on London Stock Exchange (LSE)", for: .normal)
            guard let name = quote.name else { return }
            readMoreURL = ReadMoreURLs.LSE_EXCHANGE_URL(symbol: quote.symbol, name: name)
        case "AQS":
            readMoreButtonPart.setTitle("Read more on Aquis Stock Exchange (AQSE)", for: .normal)
            readMoreURL = ReadMoreURLs.AQUIS_EXCHANGE_URL(symbol: quote.symbol)
        case "ASX":
            readMoreButtonPart.setTitle("Read more on Australian Securities Exchange (ASX)", for: .normal)
            readMoreURL = ReadMoreURLs.ASX_EXCHANGE_URL(symbol: quote.symbol)
        default:
            readMoreButtonPart.setTitle("Read more on Yahoo Finance", for: .normal)
            readMoreURL = ReadMoreURLs.YAHOO_FINANCE_URL(symbol: quote.symbol)
        }
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let profile = notification.object as? Profile else { return }
        industryDataPart.title = profile.industry
        sectorDataPart.title = profile.sector
    }
}

extension ProfileCardController {
    @objc private func readMoreButtonTapped() {
        guard let url = readMoreURL else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
