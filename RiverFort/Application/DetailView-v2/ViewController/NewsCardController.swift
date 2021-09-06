//
//  NewsCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import UIKit
import CardParts

class NewsCardController: TemplateCardController {
    private let titlePart = CardPartTitleView(type: .titleOnly)
    private let newsTableView = CardPartTableView()
    private let newsViewModel = NewsViewModel()
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

extension NewsCardController {
    private func configTitleView() {
        titlePart.title = "News"
        titlePart.label.numberOfLines = 0
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configTableViewModel() {
        newsViewModel.rssItems.asObservable().bind(to: newsTableView.tableView.rx.items) { tableView, index, data in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: IndexPath(item: index, section: 0)) as? CardPartTableViewCell else { return UITableViewCell() }
                      
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.accessoryType = .disclosureIndicator
                        
            cell.leftTitleLabel.text = data.title
            cell.leftTitleLabel.numberOfLines = 2
            cell.leftTitleLabel.textColor = .label
            cell.leftTitleFont = .preferredFont(forTextStyle: .headline)
            cell.leftTitleLabel.adjustsFontForContentSizeCategory = true
            
            cell.leftDescriptionLabel.text = data.pubDate
            cell.leftDescriptionLabel.textColor = .secondaryLabel
            cell.leftDescriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
            cell.leftDescriptionLabel.adjustsFontForContentSizeCategory = true
            return cell
        }.disposed(by: bag)
    }
    
    private func configTableView() {
        newsTableView.delegate = self
        newsTableView.tableView.backgroundColor = .secondarySystemGroupedBackground
        newsTableView.tableView.separatorColor = .systemGray
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardPartSV.addArrangedSubview(titlePart)
    }
    
    private func configCardParts() {
        configTitleView()
        configTableViewModel()
        configTableView()
        configStackView()
        setupCardParts([cardPartSV])
    }
}

extension NewsCardController: CardPartTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension NewsCardController {
    private func createObservesr() {
        let aName = Notification.Name(NewDetailViewConstant.YAHOO_FINANCE_QUOTE_RESULT)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let yahooFinanceQuoteResult = notification.object as? YahooFinanceQuoteResult else {
            return
        }
        let yahooFinanceQuote = yahooFinanceQuoteResult.optionChain.result[0].quote
        let market = yahooFinanceQuote.market
        switch market {
        case "gb_market":
            cardPartSV.addArrangedSubview(newsTableView)
            newsViewModel.fetchRSSFeedsUK(symbol: yahooFinanceQuote.symbol)
        default:
            return
        }
    }
}
