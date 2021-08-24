//
//  SettingsTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit
import SafariServices
import MessageUI

class SettingsTableView: UITableView {
    private var settingsSections = [SettingsSection]()
        
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
        self.register(SettingsStaticTableViewCell.self, forCellReuseIdentifier: SettingsTableViewConstant.STATIC_TABLE_VIEW_CELL)
        self.register(SettingsSwitchTableViewCell.self, forCellReuseIdentifier: SettingsTableViewConstant.SWITCH_TABLE_VIEW_CELL)
    }
    
    private func getShareActivityViewController() -> UIActivityViewController {
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/riverfort/id1561144335")
        let activityViewController = UIActivityViewController(activityItems: ["Try RiverFort", appStoreURL!], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: (UIApplication.topViewController()?.view.bounds.minX)!,
                                                  y: (UIApplication.topViewController()?.view.bounds.minY)!, width: 0, height: 0)
            popoverController.sourceView = UIApplication.topViewController()?.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        return activityViewController
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
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingsTableViewConstant.STATIC_TABLE_VIEW_CELL,
                    for: indexPath) as? SettingsStaticTableViewCell else { return UITableViewCell() }
            cell.setSettingsStaticTableViewCell(newSettingsStaticOption: newSettingsStaticOption)
            return cell
        case .switchCell(newSettingsSwitchOption: let newSettingsSwitchOption):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingsTableViewConstant.SWITCH_TABLE_VIEW_CELL,
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
        if UserDefaults.standard.isDarkModeEnabled() {
            self.settingsSections.append(SettingsSection(title: "Appearance", options: [
                .switchCell(newSettingsSwitchOption: SettingsSwitchOption(title: SettingsSectionTitleConstant.DARK_MODE, icon: UIImage(systemName: "sunset.fill"), iconBackgroundColour: .black, isOn: true, handler: {
                }))
            ]))
        } else {
            self.settingsSections.append(SettingsSection(title: "Appearance", options: [
                .switchCell(newSettingsSwitchOption: SettingsSwitchOption(title: SettingsSectionTitleConstant.DARK_MODE, icon: UIImage(systemName: "sunset.fill"), iconBackgroundColour: .black, isOn: false, handler: {
                }))
            ]))
        }
        self.settingsSections.append(SettingsSection(title: "Other", options: [
            .staticCell(newSettingsStaticOption: SettingsStaticOption(title: SettingsSectionTitleConstant.SHARE, icon: UIImage(systemName: "square.and.arrow.up"), iconBackgroundColour: .systemGreen, handler: { [self] in
                selectShare()
            })),
            .staticCell(newSettingsStaticOption: SettingsStaticOption(title: SettingsSectionTitleConstant.PRIVACY_AND_TERMS, icon: UIImage(systemName: "person.fill.viewfinder"), iconBackgroundColour: .systemBlue, handler: { [self] in
                selectPrivacyTermsNotification()
            })),
        ]))
        self.settingsSections.append(SettingsSection(title: "Support", options: [
            .staticCell(newSettingsStaticOption: SettingsStaticOption(title: SettingsSectionTitleConstant.FEATURE_REQUEST, icon: UIImage(systemName: "sparkles"), iconBackgroundColour: .systemPurple, handler: { [self] in
                selectSupport(selectedTitle: SettingsSectionTitleConstant.FEATURE_REQUEST)
            })),
            .staticCell(newSettingsStaticOption: SettingsStaticOption(title: SettingsSectionTitleConstant.REPORT_AN_ISSUE, icon: UIImage(systemName: "exclamationmark.bubble"), iconBackgroundColour: .systemPink, handler: { [self] in
                selectSupport(selectedTitle: SettingsSectionTitleConstant.REPORT_AN_ISSUE)
            })),
        ]))
    }
}

extension SettingsTableView {
    private func selectPrivacyTermsNotification() {
        let name = Notification.Name(SettingsNotificationConstant.SELECT_PRIVACY_TERMS)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func selectShare() {
        UIApplication.topViewController()?.present(getShareActivityViewController(), animated: true)
    }
}

extension SettingsTableView: MFMailComposeViewControllerDelegate {
    private func selectSupport(selectedTitle title: String) {
        let logSubmissionAlert = UIAlertController(
            title: "Log Submission",
            message:
                """
                Would you like to include debugging logs with yout support ticket?
                
                Note that logs do not include personally identifiable information (PII).
                """,
            preferredStyle: .alert)
        logSubmissionAlert.addAction(UIAlertAction(title: "Don't Include", style: .default, handler: { [self] action in
            if title == SettingsSectionTitleConstant.FEATURE_REQUEST {
                selectFeatureRequest(log: "")
            }
            if title == SettingsSectionTitleConstant.REPORT_AN_ISSUE {
                selectReportAnIssue(log: "")
            }
        }))
        logSubmissionAlert.addAction(UIAlertAction(title: "Include Logs", style: .default, handler: { [self]action in
            if title == SettingsSectionTitleConstant.FEATURE_REQUEST {
                selectFeatureRequest(log: LogGenerator.LOG)
            }
            if title == SettingsSectionTitleConstant.REPORT_AN_ISSUE {
                selectReportAnIssue(log: LogGenerator.LOG)
            }
        }))
        UIApplication.topViewController()?.present(logSubmissionAlert, animated: true, completion: nil)
    }
    
    
    

    
    private func selectFeatureRequest(log: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject("Feature Request")
            mailComposeViewController.setToRecipients(["tech@riverfortcapital.com"])
            let emailBody = log
            mailComposeViewController.setMessageBody(emailBody, isHTML: false)
            UIApplication.topViewController()?.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            guard let url = URL(string: "https://qiuyangnie.github.io/privacy-policy.html") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func selectReportAnIssue(log: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject("Report an Issue")
            mailComposeViewController.setToRecipients(["tech@riverfortcapital.com"])
            let emailBody = """
                            [Include summary of issue here.]
                            \(log)
                            """
            mailComposeViewController.setMessageBody(emailBody, isHTML: false)
            UIApplication.topViewController()?.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            guard let url = URL(string: "https://qiuyangnie.github.io/privacy-policy.html") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
