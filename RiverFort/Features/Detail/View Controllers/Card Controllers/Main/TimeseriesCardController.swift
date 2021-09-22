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
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex)
        NotificationCenter.default.post(name: .timeseriesUpdated, object: nil)
    }
}

extension TimeseriesCardController {
    public func setSelectedSegmentIndex() {
        timeseriesCardPartView.segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: UserDefaults.Keys.timeseriesSelectedSegmentIndex)
    }
}
