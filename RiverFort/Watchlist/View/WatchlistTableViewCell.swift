//
//  WatchlistTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
    private let symbol        = UILabel()
    private let name          = UILabel()
    private let price         = UILabel()
    private let changePercent = UILabel()
    private let mktCap        = UILabel()
    private let date          = UILabel()
    private let symbolNameStack               = UIStackView()
    private let priceChangePercentMktCapStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSymbolLabel()
        configureNameLabel()
        configurePriceLabel()
        configureChangePercentLabel()
        configureMktCapLabel()
        configureDateLabel()
        configureSymbolNameStack()
        configurePriceChangePercentMktCapStack()
        setSymbolNameStackConstraints()
        setPriceChangePercentMktCapStackConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistTableViewCell {
    public func setWatchlistTableViewCell() {
        symbol.text = "Symbol"
        name.text = "Name"
        price.text = "1.23"
        changePercent.text = "12%"
        mktCap.text = "123,456"
        date.text = "3 Aug, 2021"
    }
}

extension WatchlistTableViewCell {
    private func configureSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
    }
    
    private func configureNameLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
        name.textColor = .systemGray
        name.numberOfLines = 0
    }
    
    private func configurePriceLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
    }
    
    private func configureChangePercentLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
    }
    
    private func configureMktCapLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
    }
    
    private func configureDateLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
    }

    private func configureSymbolNameStack() {
        addSubview(symbolNameStack)
        symbolNameStack.addArrangedSubview(symbol)
        symbolNameStack.addArrangedSubview(name)
        symbolNameStack.axis         = .vertical
        symbolNameStack.distribution = .equalSpacing
        symbolNameStack.alignment    = .leading
        symbolNameStack.spacing      = 5
    }
    
    private func configurePriceChangePercentMktCapStack() {
        addSubview(priceChangePercentMktCapStack)
        priceChangePercentMktCapStack.addArrangedSubview(price)
        priceChangePercentMktCapStack.addArrangedSubview(changePercent)
        priceChangePercentMktCapStack.addArrangedSubview(mktCap)
        priceChangePercentMktCapStack.axis         = .vertical
        priceChangePercentMktCapStack.distribution = .equalSpacing
        priceChangePercentMktCapStack.alignment    = .trailing
        priceChangePercentMktCapStack.spacing      = 5
    }
    
    private func setSymbolNameStackConstraints() {
        symbolNameStack.translatesAutoresizingMaskIntoConstraints = false
        symbolNameStack.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: (UIApplication.topViewController()?.systemMinimumLayoutMargins.leading)!).isActive = true
        symbolNameStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive         = true
        symbolNameStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive               = true
        symbolNameStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive  = true
    }
    
    private func setPriceChangePercentMktCapStackConstraints() {
        priceChangePercentMktCapStack.translatesAutoresizingMaskIntoConstraints = false
        priceChangePercentMktCapStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                constant: -(UIApplication.topViewController()?.systemMinimumLayoutMargins.leading)!).isActive = true
        priceChangePercentMktCapStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive        = true
        priceChangePercentMktCapStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive              = true
        priceChangePercentMktCapStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
    }
}
