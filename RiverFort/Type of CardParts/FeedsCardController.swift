//
//  FeedsCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/05/2021.
//

import Foundation
import CardParts
import RxCocoa
import RxSwift
import SafariServices

class FeedsCardController: CardPartsViewController {
    
    private var viewModel: FeedsViewModel
    
    private let feedsSV = CardPartStackView()
    private let newsTitle = CardPartTextView(type: .title)
    private let noNewsTitle = CardPartTextView(type: .normal)
    private let feedsTableView = CardPartTableView()
    
    init(feedsViewModel: FeedsViewModel) {
        self.viewModel = feedsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTitle.text = "News"
        newsTitle.textColor = .label
        newsTitle.font = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        noNewsTitle.text = "No Recent Stories"
        noNewsTitle.textColor = .label
        noNewsTitle.font = UIFont(name: "AvenirNext-Bold", size: 16.0)
        
        feedsSV.axis = .vertical
        feedsSV.distribution = .equalSpacing
        feedsSV.spacing = 5
        feedsSV.addArrangedSubview(newsTitle)
        feedsSV.addArrangedSubview(feedsTableView)
        feedsSV.margins = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)

        viewModel.listData.asObservable().bind(to: feedsTableView.tableView.rx.items) { tableView, index, data in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: IndexPath(item: index, section: 0)) as? CardPartTableViewCell else { return UITableViewCell() }
            tableView.separatorColor = .systemGray4
            cell.accessoryType = .disclosureIndicator
            
            cell.leftTitleLabel.text = data.title
            cell.leftTitleLabel.numberOfLines = 2
            cell.leftTitleLabel.textColor = .label
            cell.leftTitleFont = UIFont(name: "Avenir-Medium", size: 16.0)!
            
            cell.leftDescriptionLabel.text = data.pubDate
            cell.leftDescriptionLabel.textColor = .secondaryLabel
            cell.leftDescriptionLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)!

            return cell
        }.disposed(by: bag)
        
        feedsTableView.delegate = self
        
        setupCardParts([feedsSV])
    }
}

extension FeedsCardController: CardPartTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFeedURL = "https" + viewModel.listData.value[indexPath.row].link.dropFirst(4)
        guard let url = URL(string: selectedFeedURL) else {
            return
        }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension FeedsCardController: TransparentCardTrait {
    func requiresTransparentCard() -> Bool {
        true
    }
}
