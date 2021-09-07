//
//  NewPriceChartViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class NewPriceChartCardController: TemplateCardController {
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
        setupCardParts([NewPriceChartCardPartView()])
    }
}

extension NewPriceChartCardController {
    private func createObservesr() {
        let aName = Notification.Name(NewDetailViewConstant.FMP_HIST_PRICE_RESULT)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: aName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let fmpHistPriceResult = notification.object as? FMPHistPriceResult else {
            return
        }
        let histPrice = fmpHistPriceResult.historical
        print(histPrice)
    }
}
