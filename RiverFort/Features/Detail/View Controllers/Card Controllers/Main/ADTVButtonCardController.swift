//
//  ADTVButtonCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 20/09/2021.
//

import CardParts

class ADTVButtonCardController: TransparentCardController {
    private lazy var viewADTVTrendsButton = ButtonCardPartView()
    private lazy var adtvDetailVC = ADTVDetailViewController()
    
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

extension ADTVButtonCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

extension ADTVButtonCardController {
    private func configView() {
        viewADTVTrendsButton.delegate = self
        configCardParts()
    }
}

extension ADTVButtonCardController {
    private func configCardParts() {
        setupCardParts([viewADTVTrendsButton])
    }
}

extension ADTVButtonCardController: ButtonCardPartViewDelegate {
    func buttonDidTap() {
        navigationController?.pushViewController(adtvDetailVC, animated: true)
    }
}

extension ADTVButtonCardController {
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveHistoricalPrice), name: .receiveHistoricalPrice, object: nil)
    }
    
    @objc private func didReceiveHistoricalPrice(notification: Notification) {
        guard let historicalPrice = notification.object as? [HistoricalPriceQuote] else { return }
        adtvDetailVC.historicalPrice = historicalPrice
    }
}
