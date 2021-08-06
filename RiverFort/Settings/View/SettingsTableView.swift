//
//  SettingsTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

class SettingsTableView: UITableView {
    private var settingsOptions = [NewSettingsOption]()
        
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
        self.settingsOptions = Array(0...100).compactMap({
            NewSettingsOption(title: "Item \($0)", icon: UIImage(systemName: "gear"), iconBackgroundColour: .systemPink) {
                
            }
        })
    }
}

extension SettingsTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsOption = settingsOptions[indexPath.row]
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.setSettingsTableViewCell(newSettingsOption: settingsOption)
        return cell
    }
}
