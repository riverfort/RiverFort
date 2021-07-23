//
//  SearchResultCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 23/07/2021.
//

import Foundation


class SearchResultCell: UITableViewCell {
    private let symbol            = UILabel()
    private let name              = UILabel()
    private let currency          = UILabel()
    private let exchangeShortName = UILabel()
    
    private let leftStack  = UIStackView()
    private let rightStack = UIStackView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(leftStack)
        leftStack.addArrangedSubview(symbol)
        leftStack.addArrangedSubview(name)
        
        addSubview(rightStack)
        rightStack.addArrangedSubview(currency)
        rightStack.addArrangedSubview(exchangeShortName)
        
        configureSymbolLabel()
        configureNameLabel()
        configureCurrencyLabel()
        configureExchangeShortNameLabel()
        configureLeftStack()
        configureRightStack()
        
        setLeftStackConstraints()
        setRightStackConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(fmpStockTickerSearch: FMPStockTickerSearch) {
        symbol.text = fmpStockTickerSearch.symbol
        name.text = fmpStockTickerSearch.name
        currency.text = fmpStockTickerSearch.currency
        exchangeShortName.text = fmpStockTickerSearch.exchangeShortName
    }

    private func configureLeftStack() {
        leftStack.axis = .vertical
        leftStack.distribution = .equalSpacing
        leftStack.alignment = .leading
        leftStack.backgroundColor = .red
        leftStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureRightStack() {
        rightStack.axis = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.alignment = .trailing
        rightStack.backgroundColor = .blue
        rightStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
    }
    
    private func configureNameLabel() {
        name.numberOfLines = 0
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
        name.textColor = .systemGray
    }
    
    private func configureCurrencyLabel() {
        currency.numberOfLines = 0
        currency.font = .preferredFont(forTextStyle: .subheadline)
        currency.adjustsFontForContentSizeCategory = true
        currency.textColor = .systemGray
    }
        
    private func configureExchangeShortNameLabel() {
        exchangeShortName.numberOfLines = 0
        exchangeShortName.font = .preferredFont(forTextStyle: .subheadline)
        exchangeShortName.adjustsFontForContentSizeCategory = true
        exchangeShortName.textColor = .systemGray
    }
    
    private func setLeftStackConstraints() {
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        leftStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        leftStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        leftStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setRightStackConstraints() {
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        rightStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        rightStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightStack.widthAnchor.constraint(equalToConstant: (contentView.frame.width)/4).isActive = true
    }
}
