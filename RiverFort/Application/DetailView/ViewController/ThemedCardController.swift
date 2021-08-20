//
//  ThemedCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/05/2021.
//

import Foundation
import CardParts

class ThemedCardController: CardPartsViewController {
    
    private var cardPartViews = [CardPartView]()

    init(quotes: CardPartQuotesView, demoChart: CardPartPriceChartView) {
        cardPartViews.append(quotes)
        cardPartViews.append(demoChart)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(adtvChart: ADTVChartView) {
        cardPartViews.append(adtvChart)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts(cardPartViews)
        
        view.layer.cornerRadius = 22.0
        view.backgroundColor = .systemBackground
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.4
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.shadowColor = UIColor.black.cgColor
        } else {
            view.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
}

extension ThemedCardController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    view.layer.borderColor = UIColor.black.cgColor
                    view.layer.shadowColor  = UIColor.black.cgColor
                }
                else if traitCollection.userInterfaceStyle == .light {
                    view.layer.shadowColor  = UIColor.lightGray.cgColor
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension ThemedCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 25.0
    }
}

extension ThemedCardController: BorderCardTrait {
    func borderWidth() -> CGFloat {
        0
    }

    func borderColor() -> CGColor {
        UIColor.black.cgColor
    }
}
