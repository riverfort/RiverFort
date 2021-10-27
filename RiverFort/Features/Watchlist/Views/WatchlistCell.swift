//
//  WatchlistCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 26/10/2021.
//

import UIKit

class WatchlistCell: UITableViewCell {
    private let stack        = UIStackView()
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
        setConstraints()
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
        profileStack.distribution = .fillEqually
        profileStack.axis = .vertical
        
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(change)
        statsStack.distribution = .fillEqually
        statsStack.axis = .vertical
        
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(statsStack)
        stack.distribution = .fillEqually
        contentView.addSubview(stack)
    }
    
    private func updateStacksLayout() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            stack.axis = .vertical
            profileStack.alignment = .leading
            statsStack.alignment   = .leading
        } else {
            stack.axis = .horizontal
            profileStack.alignment = .leading
            statsStack.alignment   = .trailing
        }
    }
}

extension WatchlistCell {
    private func setConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    }
}

extension WatchlistCell {
    public func setCell(_ watchlistCompany: WatchlistCompany) {
        symbol.text = watchlistCompany.symbol
        name.text = watchlistCompany.name
    }
}
