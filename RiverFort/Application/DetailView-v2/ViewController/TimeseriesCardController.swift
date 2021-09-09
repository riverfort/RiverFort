//
//  TimeseriesCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import UIKit
import CardParts

class TimeseriesCardController: TransparentTemplateCardController {
    private let timeseriesCardPartView = TimeseriesCardPartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardParts()
    }
}

extension TimeseriesCardController {
    private func configCardParts() {
        configSegmentedControl()
        setupCardParts([timeseriesCardPartView])
    }
}

extension TimeseriesCardController {
    private func configSegmentedControl() {
        let timeseriesDefaultIndex = 5
        let timeseriesDefaultIndexDict = ["timeseriesDefaultIndex": timeseriesDefaultIndex]
        let timeseriesDefaultIndexName = Notification.Name(NewDetailViewConstant.TIMESERIES_DEFAULT_INDEX)
        NotificationCenter.default.post(name: timeseriesDefaultIndexName, object: nil, userInfo: timeseriesDefaultIndexDict)
        timeseriesCardPartView.segmentedControl.addTarget(self, action: #selector(segmentedControlHandled), for: .valueChanged)
        timeseriesCardPartView.segmentedControl.selectedSegmentIndex = timeseriesDefaultIndex
    }
    
    @objc private func segmentedControlHandled(_ sender: UISegmentedControl) {
        HapticsManager.shared.impact(style: .light)
        let selectedSegmentIndexDict = ["selectedSegmentIndex": sender.selectedSegmentIndex]
        let timeseriesChangedName = Notification.Name(NewDetailViewConstant.TIMESERIES_CHANGED)
        NotificationCenter.default.post(name: timeseriesChangedName, object: nil, userInfo: selectedSegmentIndexDict)
    }
}
