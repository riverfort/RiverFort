//
//  NewADTVChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class NewADTVChartCardController: BaseCardController {
    private let adtvChartPart = NewADTVChartCardPartView()
    
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
        setupCardParts([adtvChartPart])
    }
}

extension NewADTVChartCardController {
    private func createObservesr() {
        let timeseriesChangedName = Notification.Name(NewDetailViewConstant.TIMESERIES_CHANGED)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareChartTimeseries), name: timeseriesChangedName, object: nil)
        let adtvName = Notification.Name(NewDetailViewConstant.ADTV)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: adtvName, object: nil)
    }
    
    @objc private func prepareChartTimeseries(notification: Notification) {
        adtvChartPart.changeTimeseries(for: UserDefaults.standard.integer(forKey: "timeseriesSelectedSegmentIndex"))
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let adtvs = notification.object as? [NewADTV] else {
            return
        }
        adtvChartPart.setChartDataForADTV(with: adtvs)
    }
}
