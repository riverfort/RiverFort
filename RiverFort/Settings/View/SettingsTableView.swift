//
//  SettingsTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

class SettingsTableView: UITableView {
    private var settingsSections = [NewSettingsSection]()
        
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
        setSettingsOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTableView {
    private func configTableView() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .systemBackground
        self.register(SettingsStaticTableViewCell.self, forCellReuseIdentifier: SettingsConstant.STATIC_TABLE_VIEW_CELL)
        self.register(SettingsSwitchTableViewCell.self, forCellReuseIdentifier: SettingsConstant.SWITCH_TABLE_VIEW_CELL)
    }
}

extension SettingsTableView {
    private func setSettingsOptions() {
        self.settingsSections.append(NewSettingsSection(title: "General", options: [
            .switchCell(newSettingsSwitchOption: NewSettingsSwitchOption(title: "Airplane mode", icon: UIImage(systemName: "airplane"), iconBackgroundColour: .blue, handler: {
                
            }, isOn: true))
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "General", options: [
            .staticCell(newSettingsOption: NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "Information", options: [
            .staticCell(newSettingsOption: NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "Apps", options: [
            .staticCell(newSettingsOption: NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
            .staticCell(newSettingsOption: NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            })),
        ]))
    }
}

extension SettingsTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let settingsSection = settingsSections[section]
        return settingsSection.title
    }
}

extension SettingsTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsOption = settingsSections[indexPath.section].options[indexPath.row]
        
        switch settingsOption.self {
        case .staticCell(newSettingsOption: let settingsOption):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: SettingsConstant.STATIC_TABLE_VIEW_CELL, for: indexPath) as? SettingsStaticTableViewCell else {
                return UITableViewCell()
            }
            cell.setSettingsTableViewCell(newSettingsOption: settingsOption)
            return cell
        case .switchCell(newSettingsSwitchOption: let settingsOption):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: SettingsConstant.SWITCH_TABLE_VIEW_CELL, for: indexPath) as? SettingsSwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.setSettingsTableViewCell(newSettingsOption: settingsOption)
            return cell
        }
    }
}

extension SettingsTableView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsOptionType = settingsSections[indexPath.section].options[indexPath.row]
        switch settingsOptionType.self {
        case .staticCell(newSettingsOption: let settingsOption):
            settingsOption.handler()
        case .switchCell(newSettingsSwitchOption: let settingsOption):
            settingsOption.handler()
        }
    }
}
