//
//  NewWatchlistTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/09/2021.
//

import UIKit

class NewWatchlistTableViewCell: UITableViewCell {
    private let systemMinimumLayoutMarginsLeading = (UIApplication.topViewController()?.systemMinimumLayoutMargins.leading)!
    private let symbol        = UILabel()
    private let name          = UILabel()
    private let currency      = UILabel()
    private let price         = UILabel()
    private let changePercent = UILabel()
    private let mktCap        = UILabel()
    private let date          = UILabel()
    private let leftStack  = UIStackView()
    private let rightStack = UIStackView()
    public let dataButton = UIButton(type: .roundedRect)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewWatchlistTableViewCell {
    private func configContentView() {
        contentView.isUserInteractionEnabled = true
        configSymbolLabel()
        configNameLabel()
        configCurrencyLabel()
        configPriceLabel()
        configChangePercentLabel()
        configMktCapLabel()
        configDateLabel()
        configStacks()
        setStacksConstraints()
    }
    
    private func configSymbolLabel() {
        symbol.font = .preferredFont(forTextStyle: .headline)
        symbol.adjustsFontForContentSizeCategory = true
    }
    
    private func configNameLabel() {
        name.font = .preferredFont(forTextStyle: .subheadline)
        name.adjustsFontForContentSizeCategory = true
        name.textColor = .systemGray
    }
    
    private func configCurrencyLabel() {
        currency.font = .preferredFont(forTextStyle: .body)
        currency.adjustsFontForContentSizeCategory = true
        currency.textColor = .systemGray
    }
    
    private func configPriceLabel() {
        price.font = .preferredFont(forTextStyle: .headline)
        price.adjustsFontForContentSizeCategory = true
    }
    
    private func configChangePercentLabel() {
        changePercent.font = .preferredFont(forTextStyle: .body)
        changePercent.adjustsFontForContentSizeCategory = true
    }
    
    private func configMktCapLabel() {
        mktCap.font = .preferredFont(forTextStyle: .body)
        mktCap.adjustsFontForContentSizeCategory = true
    }
    
    private func configDateLabel() {
        date.font = .preferredFont(forTextStyle: .body)
        date.adjustsFontForContentSizeCategory = true
    }
    
    private func configStacks() {
        addSubview(leftStack)
        leftStack.addArrangedSubview(symbol)
        leftStack.addArrangedSubview(name)
        leftStack.axis         = .vertical
        leftStack.distribution = .equalSpacing
        leftStack.alignment    = .leading
        
        addSubview(rightStack)
        rightStack.addArrangedSubview(price)
        rightStack.addArrangedSubview(dataButton)
        rightStack.axis         = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.alignment    = .trailing
    }
        
    private func setStacksConstraints() {
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        leftStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: systemMinimumLayoutMarginsLeading).isActive = true
        
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        rightStack.leadingAnchor.constraint(equalTo: leftStack.trailingAnchor).isActive = true
        rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -systemMinimumLayoutMarginsLeading).isActive = true
        setDataButtonConstraints()
    }
    
    private func setDataButtonConstraints() {
        dataButton.layer.cornerRadius = 5
        dataButton.setTitleColor(.systemBackground, for: .normal)
        dataButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        dataButton.titleLabel?.adjustsFontForContentSizeCategory = true
        dataButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 4, bottom: 3, right: 4)
        dataButton.contentHorizontalAlignment = .right
        
        dataButton.translatesAutoresizingMaskIntoConstraints = false
        dataButton.widthAnchor.constraint(equalTo: rightStack.widthAnchor, multiplier: 1).isActive = true
        dataButton.heightAnchor.constraint(equalTo: rightStack.heightAnchor, multiplier: 0.5).isActive = true
    }
}

extension NewWatchlistTableViewCell {
    private func setDataButtonBackgroundColour(changePercent: Double) {
        if changePercent < 0 {
            dataButton.backgroundColor = .systemRed
        } else {
            dataButton.backgroundColor = .systemGreen
        }
    }
    
    private func setPriceLabelText(watchedCompanyDetail: WatchedCompanyDetail) {
        guard let windowInterfaceOrientation = WindowInterfaceOrientation.windowInterfaceOrientation else { return }
        if windowInterfaceOrientation.isLandscape {
            price.text  = "\(watchedCompanyDetail.currency) \(watchedCompanyDetail.price)"
        } else {
            price.text  = "\(watchedCompanyDetail.price)"
        }
    }
}

extension NewWatchlistTableViewCell {
    public func setWatchlistTableViewCell(watchedCompanyDetail: WatchedCompanyDetail) {
        symbol.text = watchedCompanyDetail.symbol
        name.text   = watchedCompanyDetail.name
        mktCap.text = NumberShortScale.formatNumber(watchedCompanyDetail.mktCap)
        date.text   = "\(watchedCompanyDetail.mktDate)"
        changePercent.text = watchedCompanyDetail.changePercent < 0 ? "\(watchedCompanyDetail.changePercent)%" : "+\(watchedCompanyDetail.changePercent)%"
        setPriceLabelText(watchedCompanyDetail: watchedCompanyDetail)
        setDataButtonBackgroundColour(changePercent: watchedCompanyDetail.changePercent)
    }
    
    public func setDataButtonTitle(isChangePercentInDataButton: Bool) {
        if isChangePercentInDataButton {
            dataButton.setTitle(changePercent.text, for: .normal)
        } else {
            dataButton.setTitle(mktCap.text, for: .normal)
        }
    }
}
