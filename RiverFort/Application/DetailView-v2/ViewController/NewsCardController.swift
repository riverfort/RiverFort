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
        titlePart.titleColor = .label
        titlePart.titleFont = .preferredFont(forTextStyle: .headline)
        titlePart.label.adjustsFontForContentSizeCategory = true
    }
    
    private func configTableViewModel() {
        newsViewModel.rssItems.asObservable().bind(to: newsTableView.tableView.rx.items) { tableView, index, data in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.textLabel?.text = data.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
            cell.textLabel?.adjustsFontForContentSizeCategory = true

            cell.detailTextLabel?.text = data.pubDate
            cell.detailTextLabel?.textColor = .secondaryLabel
            cell.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
            cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
            return cell
        }.disposed(by: bag)
    }
    
    private func configTableView() {
        newsTableView.delegate = self
        newsTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newsTableView.tableView.backgroundColor = .secondarySystemGroupedBackground
        newsTableView.tableView.separatorStyle = .none
    }
    
    private func configStackView() {
        cardPartSV.axis = .vertical
        cardPartSV.spacing = 5
        cardPartSV.distribution = .equalSpacing
        cardPartSV.margins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
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
        return UITableView.automaticDimension
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
