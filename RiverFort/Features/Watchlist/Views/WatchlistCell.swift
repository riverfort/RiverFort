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
        symbol.text = "Symbol"
    }
    
    private func configNameLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
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
    private func configStacks() {
        profileStack.addArrangedSubview(symbol)
        profileStack.addArrangedSubview(name)
        profileStack.axis = .vertical
        profileStack.alignment = .leading
        profileStack.distribution = .fillEqually
        
        statsStack.addArrangedSubview(price)
        statsStack.addArrangedSubview(change)
        statsStack.axis = .vertical
        statsStack.alignment = .trailing
        statsStack.distribution = .fillEqually
        
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(statsStack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        contentView.addSubview(stack)
    }
}

extension WatchlistCell {
    private func setConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}
