//
//  WatchlistCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 26/10/2021.
//

import UIKit

class WatchlistCell: UITableViewCell {
    public let statsButton  = UIButton(type: .system)
    private let symbol = UILabel()
    private let name   = UILabel()
    private let price  = UILabel()
    private let profileStack = UIStackView()
    private let statsStack   = UIStackView()
    private let hStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configLabels()
        configHStack()
        setHStackConstraints()
        configStatsButton()
        setStatsButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Labels config

extension WatchlistCell {
    private func configLabels() {
        configSymbolLabel()
        configNameLabel()
        configPriceLabel()
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
}

// MARK: - Button config

extension WatchlistCell {
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

// MARK: - Stack config

extension WatchlistCell {
    private func configHStack() {
        updateHStackLayout()
        profileStack.addArrangedSubview(symbol)
        profileStack.addArrangedSubview(name)
        profileStack.axis = .vertical
        
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(statsButton)
        statsStack.axis = .vertical
        
        hStack.addArrangedSubview(profileStack)
        hStack.addArrangedSubview(statsStack)
        contentView.addSubview(hStack)
    }
    
    private func updateHStackLayout() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            hStack.axis = .vertical
            profileStack.alignment = .leading
            statsStack.alignment   = .leading
            name.numberOfLines = 0
        } else {
            hStack.axis = .horizontal
            profileStack.alignment = .leading
            statsStack.alignment   = .trailing
            name.numberOfLines = 1
        }
    }
}

// MARK: - Constraints config

extension WatchlistCell {
    private func setHStackConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    private func setStatsButtonConstraints() {
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

// MARK: - setEditing

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

// MARK: - Cell data update

extension WatchlistCell {
    private func updateCell(_ watchlistCompany: WatchlistCompany) {
        if let price = watchlistCompany.price, let change = watchlistCompany.change, let changePercent = watchlistCompany.changePercent {
            let priceDisp  = price < 10 ? String.localizedStringWithFormat("%.4f", price) : String.localizedStringWithFormat("%.2f", price)
            let changeDisp = price < 10 ? String.localizedStringWithFormat("%.4f", change) : String.localizedStringWithFormat("%.2f", change)
            let changePercentDisp = String.localizedStringWithFormat("%.2f", changePercent)
            self.price.text = priceDisp
            self.statsButton.backgroundColor = change < 0 ? .systemRed : .systemGreen
            switch UserDefaults.watchlistStatsButtonStateIndex {
            case 0:
                self.statsButton.setTitle(changeDisp, for: .normal)
            case 1:
                self.statsButton.setTitle("\(changePercentDisp)%", for: .normal)
            default:
                self.statsButton.setTitle(changeDisp, for: .normal)
            }
        } else {
            self.price.text = "-"
            self.statsButton.setTitle("--", for: .normal)
            self.statsButton.backgroundColor = .systemGray
        }
    }
}

extension WatchlistCell {
    public func setCell(_ watchlistCompany: WatchlistCompany) {
        symbol.text = watchlistCompany.symbol
        name.text = watchlistCompany.name
        updateCell(watchlistCompany)
    }
}
