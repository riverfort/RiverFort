//
//  SettingsOption.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import Foundation

struct NewSettingsStaticOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColour: UIColor
    let handler: (() -> Void)
}

struct NewSettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColour: UIColor
    var isOn: Bool
    let handler: (() -> Void)
}

enum NewSettingsOptionType {
    case staticCell(newSettingsStaticOption: NewSettingsStaticOption)
    case switchCell(newSettingsSwitchOption: NewSettingsSwitchOption)
}
