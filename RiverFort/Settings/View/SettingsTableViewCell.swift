//
//  SettingsTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    private let iconImageViewContainer = UIView()
    private let iconImageView = UIImageView()
    private let settingsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configContentView()
        configIconImageViewContainer()
        configIconImageView()
        configSettingsLabel()
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageViewContainer.backgroundColor = nil
        iconImageView.image = nil
        settingsLabel.text  = nil
    }
}

extension SettingsTableViewCell {
    private func configContentView() {
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
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
        settingsLabel.numberOfLines = 1
    }
}

extension SettingsTableViewCell {
    public func setSettingsTableViewCell(newSettingsOption: NewSettingsOption) {
        iconImageViewContainer.backgroundColor = newSettingsOption.iconBackgroundColour
        iconImageView.image = newSettingsOption.icon
        settingsLabel.text  = newSettingsOption.title
    }
}
