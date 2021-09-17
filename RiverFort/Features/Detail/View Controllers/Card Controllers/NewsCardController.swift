//
//  NewsCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/09/2021.
//

import CardParts
import SafariServices

class NewsCardController: BaseCardController {
    private lazy var titlePart     = CardPartTitleView(type: .titleOnly)
    private lazy var newsTableView = CardPartTableView()
    private lazy var readMoreButtonPart = CardPartButtonView()
    private lazy var readMoreURL = URL(string: "")
    private lazy var newsViewModel = NewsViewModel()
    private lazy var newsItems = [RSSItem]()
    
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

extension NewsCardController {
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
        titlePart.margins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    private func configTableView() {
        newsTableView.delegate = self
        newsTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newsTableView.tableView.backgroundColor = .secondarySystemGroupedBackground
        newsTableView.tableView.separatorStyle = .none
        newsTableView.margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    private func configButton() {
        readMoreButtonPart.setTitle("Read more", for: .normal)
        readMoreButtonPart.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        readMoreButtonPart.titleLabel?.adjustsFontForContentSizeCategory = true
        readMoreButtonPart.setTitleColor(.link, for: .normal)
        readMoreButtonPart.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        readMoreButtonPart.margins = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
    }
    
    private func configCardParts() {
        configTitleView()
        configTableViewModel()
        configTableView()
        configButton()
        setupCardParts([titlePart, newsTableView, readMoreButtonPart])
    }
}

extension NewsCardController {
    private func configTableViewModel() {
        newsViewModel.rssItemsForNews.asObservable().bind(to: newsTableView.tableView.rx.items) { [self] tableView, index, data in
            newsItems.append(data)
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
}

extension NewsCardController: CardPartTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: NewsURLs.UK_INVESTEGATE_COMPANY_ANNOUNCEMENT_LINK_ADJUSTED_URL(link: newsItems[indexPath.row].link)) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NewsCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: .receiveQuote, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let quote = notification.object as? Quote else { return }
        let market = quote.market
        switch market {
        case "gb_market":
            readMoreButtonPart.setTitle("Read more on Investegate", for: .normal)
            readMoreURL = URL(string: NewsURLs.UK_INVESTEGATE_COMPANY_ANNOUNCEMENTS_URL(symbol: quote.symbol))
            newsViewModel.fetchRSSFeedsUK(symbol: quote.symbol, timeseries: 15)
        default:
            newsTableView.tableView.isHidden = true
            return
        }
    }
}

extension NewsCardController {
    @objc private func readMoreButtonTapped() {
        guard let url = readMoreURL else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
