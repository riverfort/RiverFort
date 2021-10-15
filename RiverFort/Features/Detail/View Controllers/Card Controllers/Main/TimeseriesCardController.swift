//
//  TimeseriesCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import CardParts

class TimeseriesCardController: TransparentCardController {
    private lazy var timeseriesCardPartView = TimeseriesCardPartView()
}

extension TimeseriesCardController {
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
        timeseriesCardPartView.segmentedControl.addTarget(self, action: #selector(segmentedControlHandled), for: .valueChanged)
    }
    
    @objc private func segmentedControlHandled(_ sender: UISegmentedControl) {
        HapticsManager.shared.impact(style: .light)
        UserDefaults.timeseriesSelectedSegmentIndex = sender.selectedSegmentIndex
        NotificationCenter.default.post(name: .hasUpdatedTimeSeries, object: nil)
    }
}

extension TimeseriesCardController {
    public func setSelectedSegmentIndex() {
        timeseriesCardPartView.segmentedControl.selectedSegmentIndex = UserDefaults.timeseriesSelectedSegmentIndex
    }
}
