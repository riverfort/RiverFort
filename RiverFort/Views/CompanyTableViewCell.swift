//
//  CompanyTableViewCell.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import UIKit
import TinyConstraints

class CompanyTableViewCell: UITableViewCell {
    
    private var company: Company?
    
    private let companyTickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Constants.COMPANY_CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let stackView = UIStackView(arrangedSubviews: [companyTickerLabel, companyNameLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 3
        contentView.addSubview(stackView)
        stackView.leading(to: contentView, offset: 10)
        stackView.centerY(to: contentView)
    }
    
    public func setCell(_ c: Company) {
        self.company = c
        
        guard self.company != nil else {
            return
        }

        self.companyTickerLabel.text = company!.company_ticker
        self.companyNameLabel.text   = company!.company_name
    }
}
