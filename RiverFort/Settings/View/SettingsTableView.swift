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
        let settingsOptionType = settingsSections[indexPath.section].options[indexPath.row]
        switch settingsOptionType.self {
        case .staticCell(newSettingsStaticOption: let newSettingsStaticOption):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsConstant.STATIC_TABLE_VIEW_CELL,
                                                           for: indexPath) as? SettingsStaticTableViewCell else { return UITableViewCell() }
            cell.setSettingsStaticTableViewCell(newSettingsStaticOption: newSettingsStaticOption)
            return cell
        case .switchCell(newSettingsSwitchOption: let newSettingsSwitchOption):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsConstant.SWITCH_TABLE_VIEW_CELL,
                                                           for: indexPath) as? SettingsSwitchTableViewCell else { return UITableViewCell() }
            cell.setSettingsSwitchTableViewCell(newSettingsSwitchOption: newSettingsSwitchOption)
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension SettingsTableView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsOptionType = settingsSections[indexPath.section].options[indexPath.row]
        switch settingsOptionType.self {
        case .staticCell(newSettingsStaticOption: let newSettingsStaticOption):
            newSettingsStaticOption.handler()
        case .switchCell(newSettingsSwitchOption: let newSettingsSwitchOption):
            newSettingsSwitchOption.handler()
        }
    }
}

extension SettingsTableView {
    private func setSettingsOptions() {
        self.settingsSections.append(NewSettingsSection(title: "Appearance", options: [
            .switchCell(newSettingsSwitchOption: NewSettingsSwitchOption(title: "Dark Mode", icon: UIImage(systemName: "sunset.fill"), iconBackgroundColour: .black, isOn: true, handler: {
                
            }))
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "Other", options: [
            .staticCell(newSettingsStaticOption: NewSettingsStaticOption(title: "Share", icon: UIImage(systemName: "square.and.arrow.up"), iconBackgroundColour: .systemGreen, handler: {
                print("hi")
            })),
            .staticCell(newSettingsStaticOption: NewSettingsStaticOption(title: "Privacy & Terms", icon: UIImage(systemName: "person.fill.viewfinder"), iconBackgroundColour: .systemBlue, handler: { [self] in
                selectPrivacyTermsNotification()
            })),
        ]))
    }
}

extension SettingsTableView {
    private func selectPrivacyTermsNotification() {
        let name = Notification.Name(SettingsConstant.SELECT_PRIVACY_TERMS)
        NotificationCenter.default.post(name: name, object: nil)
    }
}
