//
//  WatchlistTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
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
    private let dataButton = UIButton(type: .roundedRect)
    private var isChangePercent = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configContentView()
        
        setStacksConstraints()
        setDataButtonConstraints()
        
        configSymbolLabel()
        configNameLabel()
        configCurrencyLabel()
        configPriceLabel()
        configChangePercentLabel()
        configMktCapLabel()
        configDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistTableViewCell {
    public func setWatchlistTableViewCell(watchedCompanyDetail: WatchedCompanyDetailNew) {
        symbol.text = watchedCompanyDetail.symbol
        name.text = watchedCompanyDetail.name
        price.text = "\(watchedCompanyDetail.price)"
        changePercent.text = "\(watchedCompanyDetail.changePercent)"
        mktCap.text = "\(watchedCompanyDetail.mktCap)"
        date.text = "\(watchedCompanyDetail.mktDate)"
        
        if isChangePercent {
            dataButton.setTitle(changePercent.text, for: .normal)
        } else {
            dataButton.setTitle(mktCap.text, for: .normal)
        }
    }
}

extension WatchlistTableViewCell {
    private func configContentView() {
        contentView.isUserInteractionEnabled = true
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
        price.font = .preferredFont(forTextStyle: .body)
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
        
    private func setStacksConstraints() {
        addSubview(leftStack)
        leftStack.addArrangedSubview(symbol)
        leftStack.addArrangedSubview(name)
        leftStack.axis         = .vertical
        leftStack.distribution = .equalSpacing
        leftStack.alignment    = .leading
        leftStack.backgroundColor = .systemTeal
        
        addSubview(rightStack)
        rightStack.addArrangedSubview(price)
        rightStack.addArrangedSubview(dataButton)
        rightStack.axis         = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.alignment    = .trailing
        rightStack.backgroundColor = .systemGreen
        
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
    }
    
    private func setDataButtonConstraints() {
        dataButton.backgroundColor = .systemRed
        dataButton.layer.cornerRadius = 5
        dataButton.setTitleColor(.systemBackground, for: .normal)
        dataButton.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        dataButton.titleLabel?.adjustsFontForContentSizeCategory = true
        dataButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        dataButton.contentHorizontalAlignment = .right
        dataButton.addTarget(self, action: #selector(switchData), for: .touchUpInside)
        
        dataButton.translatesAutoresizingMaskIntoConstraints = false
        dataButton.widthAnchor.constraint(equalTo: rightStack.widthAnchor, multiplier: 1).isActive = true
        dataButton.heightAnchor.constraint(equalTo: rightStack.heightAnchor, multiplier: 0.5).isActive = true
    }
}

extension WatchlistTableViewCell {
    @objc private func switchData() {
        if isChangePercent {
            isChangePercent = false
            reloadWatchlistTableViewNotification()
            print("mkt cap")
        } else {
            isChangePercent = true
            reloadWatchlistTableViewNotification()
            print("change percent")
        }
    }
}

extension WatchlistTableViewCell {
    private func reloadWatchlistTableViewNotification() {
        let name = Notification.Name(WatchlistConstant.RELOAD_WATCHLIST_TABLE_VIEW)
        NotificationCenter.default.post(name: name, object: nil)
    }
}
