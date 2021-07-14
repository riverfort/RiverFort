//
//  UserDefaults+.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/06/2021.
//

import Foundation

extension UserDefaults {
    
    func setDarkModeEnabled(value: Bool) {
        setValue(value, forKey: UserDefaultsKeys.isDarkMode.rawValue)
    }
    
    func isDarkModeEnabled() -> Bool {
        return bool(forKey: UserDefaultsKeys.isDarkMode.rawValue)
    }
}

enum UserDefaultsKeys : String {
    case isDarkMode
}
