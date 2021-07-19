//
//  SettingTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/04/2021.
//

import UIKit

class SettingTableViewCell: UITableViewCell {    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = CGRect(
            x: 25,
            y: 0,
            width: contentView.frame.size.width - 20,
            height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model: SettingsOption) {
        label.text = model.title
    }
}

struct SettingsOption {
    let title: String
    let handler: (() -> Void)
}
