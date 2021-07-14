//
//  SettingsViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/04/2021.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sections = [Section]()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingTableViewCell.self,       forCellReuseIdentifier: Constants.SETTING_TABLE_VIEW_CELL_ID)
        tableView.register(SettingSwitchTableViewCell.self, forCellReuseIdentifier: Constants.SETTING_SWITCH_TABLE_VIEW_CELL_ID)
        tableView.register(SettingFooterView.self,          forHeaderFooterViewReuseIdentifier: Constants.SETTING_FOOTER_VIEW_CELL_ID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        configure()
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        view.addSubview(tableView)
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.init(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        switch model {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.SETTING_TABLE_VIEW_CELL_ID,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.SETTING_SWITCH_TABLE_VIEW_CELL_ID,
                for: indexPath
            ) as? SettingSwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = sections[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(_): break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}

extension SettingsViewController {
    private func configure() {
        if self.traitCollection.userInterfaceStyle == .dark {
            sections.append(Section(title: "Theme", options: [
                .switchCell(model: SettingsSwitchOption(title: "Dark Mode", isOn: true)),
            ]))
        } else if self.traitCollection.userInterfaceStyle == .light {
            sections.append(Section(title: "Theme", options: [
                .switchCell(model: SettingsSwitchOption(title: "Dark Mode", isOn: false)),
            ]))
        }

        sections.append(Section(title: "Contact", options: [
            .staticCell(model: SettingsOption(title: "Share RiverFort", handler: {
                self.presentShareSheet()
            })),
        ]))
        
        sections.append(Section(title: "Others", options: [
            .staticCell(model: SettingsOption(title: "Privacy Policy", handler: {
                let vc = PrivacyPolicyViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })),
        ]))
    }
}

extension SettingsViewController {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section > 0 else {
            return nil
        }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.SETTING_FOOTER_VIEW_CELL_ID) as? SettingFooterView
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? 120 : 0
    }
}

extension SettingsViewController {
    func presentShareSheet() {
        guard let url = URL(string: "https://apps.apple.com/us/app/riverfort/id1561144335") else {
            return
        }
        let shareSheetVC = UIActivityViewController(
            activityItems: [
                "Hey there, I wanted to tell you about RiverFort.",
                url
        ], applicationActivities: nil)        
        if let popoverController = shareSheetVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(shareSheetVC, animated: true, completion: nil)
    }
}

extension SettingsViewController {
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
}

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}
