//
//  SettingsOption.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import Foundation

struct NewSettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColour: UIColor
    let handler: (() -> Void)
}
