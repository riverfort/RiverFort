//
//  UserDefaults+.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/06/2021.
//

import Foundation

extension UserDefaults {
    struct Keys {
        static let isDarkModeOn  = "is_dark_mode_on"
        static let timeseriesSelectedSegmentIndex = "timeseries_selected_segment_index"
    }
}

extension UserDefaults {
    func setDarkModeEnabled(value: Bool) {
        setValue(value, forKey: UserDefaults.Keys.isDarkModeOn)
    }
    
    func isDarkModeEnabled() -> Bool {
        return bool(forKey: UserDefaults.Keys.isDarkModeOn)
    }
}

