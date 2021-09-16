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

