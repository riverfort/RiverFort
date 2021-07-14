//
//  WatchedCompanyTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 14/04/2021.
//

import UIKit
import TinyConstraints
import EFCountingLabel

class WatchedCompanyTableViewCell: UITableViewCell {
                
    private var company: Company?
    private var watchedCompany: WatchedCompanyDetail?
    
    private let companyTickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 14)
        return label
    }()
        
    private let priceLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 10)
        label.textAlignment = .right
        label.font = UIFont(name: "Avenir-Medium", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let changePercentLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.setUpdateBlock { value, label in
            label.text = String(format: "%.2f%%", value)
        }
        label.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 10)
        label.textAlignment = .right
        label.font = UIFont(name: "Avenir-Medium", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
        
    private let marketDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-MediumOblique", size: 14)
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ticker_name_stackView = UIStackView(arrangedSubviews: [companyTickerLabel, companyNameLabel])
        ticker_name_stackView.distribution = .fillEqually
        ticker_name_stackView.axis = .vertical
        ticker_name_stackView.spacing = 3
        contentView.addSubview(ticker_name_stackView)
        ticker_name_stackView.leading(to: contentView, offset: 10)
        ticker_name_stackView.centerY(to: contentView)
        
        let price_changePercent_stack = UIStackView(arrangedSubviews: [priceLabel, changePercentLabel, marketDateLabel])
        price_changePercent_stack.distribution = .fillEqually
        price_changePercent_stack.axis = .vertical
        price_changePercent_stack.spacing = 3
        contentView.addSubview(price_changePercent_stack)
        price_changePercent_stack.trailing(to: contentView, offset: -20)
        price_changePercent_stack.centerY(to: contentView)
    }
    
    public func setCell(_ c: Company) {
        self.company = c
        
        guard self.company != nil else {
            return
        }

        self.companyTickerLabel.text = company!.company_ticker
        self.companyNameLabel.text   = company!.company_name
    }
    
    public func setCell(_ wc: WatchedCompanyDetail) {
        self.watchedCompany = wc
        
        guard self.watchedCompany != nil else {
            return
        }
        
        if watchedCompany!.change_percent < 0 {
            changePercentLabel.textColor = .systemRed
        } else {
            changePercentLabel.textColor = .systemGreen
        }

        self.companyTickerLabel.text = watchedCompany!.company_ticker
        self.companyNameLabel.text   = watchedCompany!.company_name
        self.priceLabel.countFrom(0, to: CGFloat(watchedCompany!.close), withDuration: 0.5)
        priceLabel.setUpdateBlock { [self] value, label in
            label.text = String(format: "\(watchedCompany!.currency) %.2f", value)
        }
        self.changePercentLabel.countFrom(0, to: CGFloat(watchedCompany!.change_percent), withDuration: 0.5)
        self.marketDateLabel.text    = DateFormatterUtils.convertDateFormater(watchedCompany!.market_date)
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Constants.WATCHED_COMPANY_CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
