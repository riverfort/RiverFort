//
//  SearchV2ResultCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/08/2021.
//

import Foundation

class SearchV2ResultCell: UITableViewCell {
    private let systemMinimumLayoutMarginsLeading = (UIApplication.topViewController()?.systemMinimumLayoutMargins.leading)!
    private let symbol = UILabel()
    private let exch   = UILabel()
    private let name   = UILabel()
    private let type   = UILabel()
    private let leftStack  = UIStackView()
    private let rightStack = UIStackView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSymbolLabel()
        configExchLabel()
        configNameLabel()
        configTypeLabel()
        configSymbolAndExchStack()
        configNameAndTypeStack()
        setSymbolAndExchStackConstraint()
        setNameAndTypeStackConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchV2ResultCell {
    private func configSymbolAndExchStack() {
        addSubview(leftStack)
        leftStack.addArrangedSubview(symbol)
        leftStack.addArrangedSubview(name)
        leftStack.axis = .vertical
        leftStack.distribution = .equalSpacing
        leftStack.alignment = .leading
        leftStack.spacing = 5
    }
    
    private func configNameAndTypeStack() {
        addSubview(rightStack)
        rightStack.addArrangedSubview(exch)
        rightStack.addArrangedSubview(type)
        rightStack.axis = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.alignment = .trailing
        rightStack.spacing = 5
    }
}

extension SearchV2ResultCell {
    private func configSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
    }
    
    private func configNameLabel() {
        name.numberOfLines = 0
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
        name.textColor = .systemGray
    }
    
    private func configExchLabel() {
        exch.numberOfLines = 0
        exch.font = .preferredFont(forTextStyle: .footnote)
        exch.adjustsFontForContentSizeCategory = true
        exch.textColor = .darkGray
    }
        
    private func configTypeLabel() {
        type.numberOfLines = 0
        type.font = .preferredFont(forTextStyle: .footnote)
        type.adjustsFontForContentSizeCategory = true
        type.textColor = .systemGray
    }
}

extension SearchV2ResultCell {
    private func setSymbolAndExchStackConstraint() {
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: systemMinimumLayoutMarginsLeading).isActive = true
        leftStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        leftStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setNameAndTypeStackConstraint() {
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -systemMinimumLayoutMarginsLeading).isActive = true
        rightStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        rightStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
    }
}

extension SearchV2ResultCell {
    public func setCell(for yahooFinanceSearchedCompany: YahooFinanceSearchedCompany) {
        symbol.text = yahooFinanceSearchedCompany.symbol
        name.text = yahooFinanceSearchedCompany.name
        exch.text = yahooFinanceSearchedCompany.exch
        type.text = yahooFinanceSearchedCompany.typeDisp
    }
}
