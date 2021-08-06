//
//  SettingsTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

class SettingsSwitchTableViewCell: UITableViewCell {
    private let iconImageViewContainer = UIView()
    private let iconImageView = UIImageView()
    private let settingsLabel = UILabel()
    private let theSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configContentView()
        configIconImageViewContainer()
        configIconImageView()
        configSettingsLabel()
        configTheSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 12
        iconImageViewContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize = size/1.5
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        settingsLabel.frame = CGRect(x: 25+iconImageViewContainer.frame.size.width,
                                     y: 0,
                                     width: contentView.frame.size.width-25-iconImageViewContainer.frame.size.width,
                                     height: contentView.frame.size.height)
        
        theSwitch.sizeToFit()
        theSwitch.frame = CGRect(x: contentView.frame.size.width-theSwitch.frame.size.width-20,
                                 y: (contentView.frame.size.height-theSwitch.frame.size.height)/2,
                                 width: theSwitch.frame.size.width,
                                 height: theSwitch.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageViewContainer.backgroundColor = nil
        iconImageView.image = nil
        settingsLabel.text  = nil
        theSwitch.isOn      = false
    }
}

extension SettingsSwitchTableViewCell {
    private func configContentView() {
        contentView.clipsToBounds = true
        accessoryType = .none
    }

    private func configIconImageViewContainer() {
        contentView.addSubview(iconImageViewContainer)
        iconImageViewContainer.clipsToBounds       = true
        iconImageViewContainer.layer.cornerRadius  = 8
        iconImageViewContainer.layer.masksToBounds = true
    }
    
    private func configIconImageView() {
        iconImageViewContainer.addSubview(iconImageView)
        iconImageView.tintColor   = .white
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func configSettingsLabel() {
        contentView.addSubview(settingsLabel)
        settingsLabel.numberOfLines = 0
        settingsLabel.font = .preferredFont(forTextStyle: .body)
        settingsLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configTheSwitch() {
        contentView.addSubview(theSwitch)
    }
}

extension SettingsSwitchTableViewCell {
    public func setSettingsSwitchTableViewCell(newSettingsSwitchOption: NewSettingsSwitchOption) {
        iconImageViewContainer.backgroundColor = newSettingsSwitchOption.iconBackgroundColour
        iconImageView.image = newSettingsSwitchOption.icon
        settingsLabel.text  = newSettingsSwitchOption.title
        theSwitch.isOn      = newSettingsSwitchOption.isOn
    }
}
