//
//  ADTVChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class ADTVChartCardController: BaseCardController {
    private lazy var adtvChartPart = ADTVChartCardPartView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ADTVChartCardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([adtvChartPart])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension ADTVChartCardController {
    private func createObservesr() {
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartTimeseries), name: .hasUpdatedTimeSeries, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareADTV), name: .didReceiveHistoricalADTV, object: nil)
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        adtvChartPart.changeTimeseries(for: UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex), label: "ADTV", colour: .systemTeal)
    }
    
    @objc private func prepareADTV(notification: Notification) {
        guard let adtvs = notification.object as? [ADTV] else { return }
        adtvChartPart.setChartDataForADTV(with: adtvs, label: "ADTV", colour: .systemTeal)
    }
}
