//
//  CardPartQuotesView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/05/2021.
//

import Foundation
import CardParts
import TinyConstraints
import EFCountingLabel

struct CompanyTradingQuote: Decodable {
    let company_ticker: String
    let market_date: String
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let vwap: Double?
    let volume: Double
    let change_percent: Double
}

struct CompanyCurrency: Decodable {
    let currency: String
}

struct CompanyQuote: Decodable {
    let timestamp: String
    let price: Double
}

public class CardPartQuotesView: UIView, CardPartView {
    
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
    
    private var company: Company
    
    private lazy var companyDetail = [CompanyDetail]()
    
    // MARK: - company name and date
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - share price, change percent and currency
    private let latestPriceLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.setUpdateBlock { value, label in
            label.text = String(format: "%.2f", value)
        }
        label.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 10)
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        return label
    }()
    
    private let changePercentLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.setUpdateBlock { value, label in
            label.text = String(format: "%.2f%%", value)
        }
        label.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 10)
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-MediumOblique", size: 15)
        return label
    }()
        
    init(company: Company) {
        self.company = company
        super.init(frame: CGRect.zero)
        
        companyNameLabel.text = company.company_name
        
        // MARK: - company name and date
        let companyNameLabel_todayLabel_stack = UIStackView(arrangedSubviews: [companyNameLabel, todayLabel])
        companyNameLabel_todayLabel_stack.distribution = .fillEqually
        view.addSubview(companyNameLabel_todayLabel_stack)
        companyNameLabel_todayLabel_stack.width(to: view, offset: -30)
        companyNameLabel_todayLabel_stack.height(55)
        companyNameLabel_todayLabel_stack.centerX(to: view)

        // MARK: - share price and change percent
        let changePercentLabel_latestPriceLabel_stack = UIStackView(arrangedSubviews: [latestPriceLabel, changePercentLabel, currencyLabel])
        changePercentLabel_latestPriceLabel_stack.distribution = .fillProportionally
        changePercentLabel_latestPriceLabel_stack.spacing      = 10
        view.addSubview(changePercentLabel_latestPriceLabel_stack)
        changePercentLabel_latestPriceLabel_stack.topToBottom(of: companyNameLabel_todayLabel_stack)
        changePercentLabel_latestPriceLabel_stack.leading(to: view, offset: 15)
                
        APIFunctions.functions.companyDetailDeleagate = self
        APIFunctions.functions.fetchCompanyDetail(companyTicker: company.company_ticker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardPartQuotesView: CompanyDetailDataDelegate {
    func updateCompanyDetail(newCompanyDetail: String) {
        do {
            companyDetail = try JSONDecoder().decode([CompanyDetail].self, from: newCompanyDetail.data(using: .utf8)!)
    
            if companyDetail[0].change_percent < 0 {
                changePercentLabel.textColor = .systemRed
            } else {
                changePercentLabel.textColor = .systemGreen
            }
            
            todayLabel.text         = DateFormatterUtils.convertDateFormater(companyDetail[0].market_date)
            latestPriceLabel.countFrom(0, to: CGFloat(companyDetail[0].close), withDuration: 1)
            changePercentLabel.countFrom(0, to: CGFloat(companyDetail[0].change_percent), withDuration: 1)
            currencyLabel.text      = "(\(companyDetail[0].currency))"
        } catch {
            print("Failed to decode company details!")
        }
    }
}
