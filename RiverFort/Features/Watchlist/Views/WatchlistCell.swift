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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configLabels()
        configStacks()
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
}

extension WatchlistCell {
    private func configStacks() {
        updateStacksLayout()
        profileStack.addArrangedSubview(symbol)
        profileStack.addArrangedSubview(name)
        profileStack.distribution = .equalSpacing
        profileStack.axis = .vertical
        
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(change)
        statsStack.distribution = .equalSpacing
        statsStack.axis = .vertical
        
        fullStack.addArrangedSubview(profileStack)
        fullStack.addArrangedSubview(statsStack)
        fullStack.distribution = .equalSpacing
        contentView.addSubview(fullStack)
    }
    
    private func updateStacksLayout() {
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
    }
}

extension WatchlistCell {
    private func updateCell(_ watchlistCompany: WatchlistCompany) {
        if let price = watchlistCompany.price {
            self.price.text = price < 10 ? String.localizedStringWithFormat("%.4f", price) : String.localizedStringWithFormat("%.2f", price)
        } else {
            self.price.text = "-"
        }
    }
    
    public func setCell(_ watchlistCompany: WatchlistCompany) {
        symbol.text = watchlistCompany.symbol
        name.text = watchlistCompany.name
        updateCell(watchlistCompany)
    }
}
