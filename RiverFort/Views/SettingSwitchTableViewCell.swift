//
//  SettingSwitchTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/04/2021.
//

import UIKit

class SettingSwitchTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    public let darkModeSwitch: UISwitch = {
        let _switch = UISwitch()
        _switch.onTintColor = .systemIndigo
        return _switch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(darkModeSwitch)
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        darkModeSwitch.sizeToFit()
        darkModeSwitch.frame = CGRect(
            x: contentView.frame.size.width - darkModeSwitch.frame.size.width - 20,
            y: (contentView.frame.size.height - darkModeSwitch.frame.size.height)/2,
            width: darkModeSwitch.frame.size.width,
            height: darkModeSwitch.frame.size.height)
        
        label.frame = CGRect(
            x: 25,
            y: 0,
            width: contentView.frame.size.width - 20,
            height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        darkModeSwitch.isOn = false
    }
    
    public func configure(with model: SettingsSwitchOption) {
        label.text = model.title
        darkModeSwitch.isOn = model.isOn
        darkModeSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            print("on")
            UserDefaults.standard.setDarkModeEnabled(value: true)
            window?.overrideUserInterfaceStyle = .dark
        } else {
            print("off")
            UserDefaults.standard.setDarkModeEnabled(value: false)
            window?.overrideUserInterfaceStyle = .light
        }
    }
}

struct SettingsSwitchOption {
    let title: String
    var isOn: Bool
}
