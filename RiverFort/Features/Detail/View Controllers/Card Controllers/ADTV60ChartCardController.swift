//
//  ADTV60ChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class ADTV60ChartCardController: BaseCardController {
    private lazy var adtvChartPart = ADTVChartCardPartView()
    
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

extension ADTV60ChartCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([adtvChartPart])
    }
}

extension ADTV60ChartCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartTimeseries), name: .timeseriesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareADTV60), name: .getHistoricalADTV60, object: nil)
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        adtvChartPart.changeTimeseries(for: UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex))
    }
    
    @objc private func prepareADTV60(notification: Notification) {
        guard let adtvs = notification.object as? [ADTV] else { return }
        adtvChartPart.setChartDataForADTV(with: adtvs)
    }
}
