//
//  WatchlistCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 26/10/2021.
//

import UIKit

class WatchlistCell: UITableViewCell {
    private let fullStack    = UIStackView()
    private let profileStack = UIStackView()
    private let statsStack   = UIStackView()
    private let symbol = UILabel()
    private let name   = UILabel()
    private let price  = UILabel()
    private let change = UILabel()
    private let changePercent = UILabel()
    private let statsButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configLabels()
        configStatsButton()
        configFullStack()
        setFullStackConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistCell {
    private func configLabels() {
        configSymbolLabel()
        configNameLabel()
        configPriceLabel()
        configChangeLabel()
    }
    
    private func configSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
        symbol.text = "-"
    }
    
    private func configNameLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
        name.textColor = .secondaryLabel
        name.text = "-"
    }
    
    private func configPriceLabel() {
        price.font = .preferredFont(forTextStyle: .headline)
        price.adjustsFontForContentSizeCategory = true
        price.text = "-"
    }
        
    private func configChangeLabel() {
        change.font = .preferredFont(forTextStyle: .subheadline)
        change.adjustsFontForContentSizeCategory = true
        change.text = "-"
    }
    
    private func configStatsButton() {
        statsButton.setTitle("--", for: .normal)
        statsButton.setTitleColor(.white, for: .normal)
        statsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        statsButton.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        statsButton.layer.cornerRadius = 5
        statsButton.backgroundColor = .systemGray
        statsButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        statsButton.contentHorizontalAlignment = .right
    }
}

extension WatchlistCell {
    private func configFullStack() {
        updateFullStackLayout()
        profileStack.addArrangedSubview(symbol)
        profileStack.addArrangedSubview(name)
        profileStack.distribution = .fillEqually
        profileStack.axis = .vertical
        
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(statsButton)
        statsStack.distribution = .fillEqually
        statsStack.axis = .vertical
        
        fullStack.addArrangedSubview(profileStack)
        fullStack.addArrangedSubview(statsStack)
        fullStack.distribution = .equalSpacing
        contentView.addSubview(fullStack)
    }
    
    private func updateFullStackLayout() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            fullStack.axis = .vertical
            profileStack.alignment = .leading
            statsStack.alignment   = .leading
            name.numberOfLines = 0
        } else {
            fullStack.axis = .horizontal
            profileStack.alignment = .leading
            statsStack.alignment   = .trailing
            name.numberOfLines = 1
        }
    }
}

extension WatchlistCell {
    private func setFullStackConstraints() {
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        fullStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        fullStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        fullStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            switch traitCollection.preferredContentSizeCategory {
            case .accessibilityMedium:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.3).isActive = true
            case .accessibilityLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.35).isActive = true
            case .accessibilityExtraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.4).isActive = true
            case .accessibilityExtraExtraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.45).isActive = true
            case .accessibilityExtraExtraExtraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.5).isActive = true
            default:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.5).isActive = true
            }
        } else {
            switch traitCollection.preferredContentSizeCategory {
            case .extraSmall:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.15).isActive = true
            case .small:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.17).isActive = true
            case .medium:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.19).isActive = true
            case .large:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.21).isActive = true
            case .extraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.23).isActive = true
            case .extraExtraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.25).isActive = true
            case .extraExtraExtraLarge:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.27).isActive = true
            default:
                statsButton.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.19).isActive = true
            }
        }
    }
}

extension WatchlistCell {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            UIView.animate(withDuration: 0.25, delay: .nan, options: .curveEaseOut) { [unowned self] in
                statsStack.alpha = 0
                statsStack.isHidden = true
            }
        } else {
            statsStack.isHidden = false
            UIView.animate(withDuration: 0.25, delay: .nan, options: .curveEaseIn) { [unowned self] in
                statsStack.alpha = 1
            }
        }
    }
}

extension WatchlistCell {
    private func updateCell(_ watchlistCompany: WatchlistCompany) {
        if let price = watchlistCompany.price, let change = watchlistCompany.change {
            self.price.text = price < 10 ? String.localizedStringWithFormat("%.4f", price) : String.localizedStringWithFormat("%.2f", price)
            if change < 0 {
                statsButton.backgroundColor = .systemRed
                if price < 10 {
                    statsButton.setTitle(String.localizedStringWithFormat("%.4f", change), for: .normal)
                } else {
                    statsButton.setTitle(String.localizedStringWithFormat("%.2f", change), for: .normal)
                }
            } else {
                statsButton.backgroundColor = .systemGreen
                if price < 10 {
                    statsButton.setTitle(String.localizedStringWithFormat("+%.4f", change), for: .normal)
                } else {
                    statsButton.setTitle(String.localizedStringWithFormat("+%.2f", change), for: .normal)
                }
            }
        } else {
            self.price.text = "-"
            statsButton.setTitle("--", for: .normal)
            statsButton.backgroundColor = .systemGray
        }
    }
    
    public func setCell(_ watchlistCompany: WatchlistCompany) {
        symbol.text = watchlistCompany.symbol
        name.text = watchlistCompany.name
        updateCell(watchlistCompany)
    }
}
