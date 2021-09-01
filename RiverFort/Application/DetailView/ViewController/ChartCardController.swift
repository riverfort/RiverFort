//
//  ChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/05/2021.
//

import Foundation
import CardParts

class ChartCardController: CardPartsViewController {
    private var cardPartViews = [CardPartView]()

    init(quotesCardPartView: QuotesCardPartView, priceChartCardPartView: PriceChartCardPartView) {
        cardPartViews.append(quotesCardPartView)
        cardPartViews.append(priceChartCardPartView)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(adtvChartCardPartView: ADTVChartCardPartView) {
        cardPartViews.append(adtvChartCardPartView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configViewMode()
        setupCardParts(cardPartViews)
    }
}

extension ChartCardController {
    private func configView() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius  = 22.0
        view.layer.shadowRadius  = 10.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset  = CGSize(width: 1.0, height: 1.0)
    }
    
    private func configViewMode() {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .secondarySystemBackground
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.shadowColor = UIColor.black.cgColor
        } else if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .systemBackground
            view.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
}

extension ChartCardController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configViewMode()
            }
        }
    }
}

extension ChartCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 25.0
    }
}

extension ChartCardController: BorderCardTrait {
    func borderWidth() -> CGFloat {
        0
    }

    func borderColor() -> CGColor {
        UIColor.black.cgColor
    }
}
