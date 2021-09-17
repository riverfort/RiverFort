//
//  SettingsOption.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

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
    case staticCell(settingsStaticOption: SettingsStaticOption)
    case switchCell(settingsSwitchOption: SettingsSwitchOption)
}
