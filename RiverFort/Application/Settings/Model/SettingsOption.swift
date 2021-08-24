//
//  SettingsOption.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import Foundation

struct SettingsStaticOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColour: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColour: UIColor
    var isOn: Bool
    let handler: (() -> Void)
}

enum SettingsOptionType {
    case staticCell(newSettingsStaticOption: SettingsStaticOption)
    case switchCell(newSettingsSwitchOption: SettingsSwitchOption)
}
