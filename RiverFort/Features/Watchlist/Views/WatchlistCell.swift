//
//  WatchlistCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 26/10/2021.
//

import UIKit

class WatchlistCell: UITableViewCell {
    private let symbol = UILabel()
    private let name   = UILabel()
    private let price  = UILabel()
    private let change = UILabel()
    private let changePercent = UILabel()
    private let stack = UIStackView()
    private let profileStack = UIStackView()
    private let statsStack = UIStackView()
    private var regularConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configStack()
        configSymbolLabel()
        configNameLabel()
        configPriceLabel()
        configChangeLabel()
        setupLayoutConstraints()
        updateLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistCell {
    private func configStack() {
        addSubview(stack)
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(statsStack)
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        configProfileStack()
        configStatsStack()
    }
    
    private func configProfileStack() {
        profileStack.addArrangedSubview(symbol)
        profileStack.addArrangedSubview(name)
        profileStack.axis = .vertical
        profileStack.distribution = .equalSpacing
        profileStack.alignment = .leading
        profileStack.spacing = 5
    }
    
    private func configStatsStack() {
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(change)
        statsStack.axis = .vertical
        statsStack.distribution = .equalSpacing
        statsStack.alignment = .trailing
        statsStack.spacing = 5
    }
}

extension WatchlistCell {
    private func configSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
        symbol.text = "Symbol"
    }
    
    private func configNameLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
//        name.textColor = .secondaryLabel
//        name.numberOfLines = 0
        name.text = "Name"
    }
    
    private func configPriceLabel() {
        price.font = .preferredFont(forTextStyle: .footnote)
        price.adjustsFontForContentSizeCategory = true
        price.text = "Price"
    }
        
    private func configChangeLabel() {
        change.font = .preferredFont(forTextStyle: .footnote)
        change.adjustsFontForContentSizeCategory = true
        change.text = "Change"
    }
}

extension WatchlistCell {
    private func setupLayoutConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        regularConstraints = [
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ]
    }
    
    private func updateLayoutConstraints() {
        NSLayoutConstraint.activate(regularConstraints)
    }
}
