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
        self.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate = self
        self.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SettingsTableView {
    private func setSettingsOptions() {
        self.settingsSections.append(NewSettingsSection(title: "General", options: [
            NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "Information", options: [
            NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
        ]))
        
        self.settingsSections.append(NewSettingsSection(title: "Apps", options: [
            NewSettingsOption(title: "WIFT", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Bluetooth", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
            NewSettingsOption(title: "iCloud", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink, handler: {
                print("hi")
            }),
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
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.setSettingsTableViewCell(newSettingsOption: settingsOption)
        return cell
    }
}

extension SettingsTableView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingsOption = settingsSections[indexPath.section].options[indexPath.row]
        settingsOption.handler()
    }
}
