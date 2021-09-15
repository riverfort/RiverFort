//
//  ProfileCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/05/2021.
//

import Foundation
import CardParts

class ProfileCardController: CardPartsViewController {
    
    let possibleGradientColors: [UIColor] = [
        UIColor(red: 230.0 / 255.0, green: 242.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.3),
        UIColor(red: 204.0 / 255.0, green: 230.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.3),
    ]
    
    private var company: Company
    
    let profileSV  = CardPartStackView()
    let exchangeSV = CardPartStackView()
    let countrySV  = CardPartStackView()
    let isinSV     = CardPartStackView()

    let profileTitle  = CardPartTextView(type: .title)
    let industryTitle = CardPartTextView(type: .title)
    let sectorTitle   = CardPartTextView(type: .title)
    
    let exchangeText = CardPartTextView(type: .normal)
    let countryText  = CardPartTextView(type: .normal)
    let isinText     = CardPartTextView(type: .normal)
    
    let exchangeData = CardPartTextView(type: .normal)
    let countryData  = CardPartTextView(type: .normal)
    let isinData     = CardPartTextView(type: .normal)
    let industryData = CardPartTextView(type: .normal)
    let sectorData   = CardPartTextView(type: .normal)
    
    var _title: String = ""
    
    init(title: String, company: Company) {
        self._title = title
        self.company = company
        super.init(nibName: nil, bundle: nil)
        APIFunctions.functions.symbolProfileDeleagate = self
        APIFunctions.functions.fetchSymbolProfile(companyTicker: company.company_ticker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTitle.text  = self._title
        industryTitle.text = "Industry"
        sectorTitle.text   = "Sector"
        
        exchangeText.text  = "Exchange"
        countryText.text   = "Country"
        isinText.text      = "ISIN"

        profileTitle.font = .preferredFont(forTextStyle: .headline)
        industryTitle.font = .preferredFont(forTextStyle: .headline)
        sectorTitle.font = .preferredFont(forTextStyle: .headline)
        profileTitle.label.adjustsFontForContentSizeCategory = true
        industryTitle.label.adjustsFontForContentSizeCategory = true
        sectorTitle.label.adjustsFontForContentSizeCategory = true
        
        exchangeText.font = .preferredFont(forTextStyle: .subheadline)
        countryText.font = .preferredFont(forTextStyle: .subheadline)
        isinText.font = .preferredFont(forTextStyle: .subheadline)
        exchangeText.label.adjustsFontForContentSizeCategory = true
        countryText.label.adjustsFontForContentSizeCategory = true
        isinText.label.adjustsFontForContentSizeCategory = true
        
        exchangeData.font = .preferredFont(forTextStyle: .callout)
        countryData.font = .preferredFont(forTextStyle: .callout)
        industryData.font = .preferredFont(forTextStyle: .callout)
        sectorData.font = .preferredFont(forTextStyle: .callout)
        isinData.font = .preferredFont(forTextStyle: .callout)
        exchangeData.label.adjustsFontForContentSizeCategory = true
        countryData.label.adjustsFontForContentSizeCategory = true
        industryData.label.adjustsFontForContentSizeCategory = true
        sectorData.label.adjustsFontForContentSizeCategory = true
        isinData.label.adjustsFontForContentSizeCategory = true
        
        profileTitle.textAlignment  = .left
        industryTitle.textAlignment = .left
        sectorTitle.textAlignment   = .left
        
        profileTitle.textColor  = .label
        industryTitle.textColor = .label
        sectorTitle.textColor   = .label
        
        exchangeText.textColor = .label
        countryText.textColor  = .label
        isinText.textColor     = .label
        
        exchangeData.textColor = .label
        countryData.textColor  = .label
        industryData.textColor = .label
        sectorData.textColor   = .label
        isinData.textColor     = .label
    
        exchangeSV.axis = .horizontal
        exchangeSV.distribution = .equalSpacing
        exchangeSV.addArrangedSubview(exchangeText)
        exchangeSV.addArrangedSubview(exchangeData)
        
        countrySV.axis = .horizontal
        countrySV.distribution = .equalSpacing
        countrySV.addArrangedSubview(countryText)
        countrySV.addArrangedSubview(countryData)
        
        isinSV.axis = .horizontal
        isinSV.distribution = .equalSpacing
        isinSV.addArrangedSubview(isinText)
        isinSV.addArrangedSubview(isinData)
        
        profileSV.axis = .vertical
        profileSV.distribution = .equalSpacing
        profileSV.spacing = 5
        profileSV.addArrangedSubview(profileTitle)
        profileSV.addArrangedSubview(exchangeSV)
        profileSV.addArrangedSubview(CardPartSeparatorView())
        profileSV.addArrangedSubview(countrySV)
        profileSV.addArrangedSubview(CardPartSeparatorView())
        profileSV.addArrangedSubview(isinSV)
        profileSV.addArrangedSubview(industryTitle)
        profileSV.addArrangedSubview(industryData)
        profileSV.addArrangedSubview(sectorTitle)
        profileSV.addArrangedSubview(sectorData)
        profileSV.margins = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
                
        setupCardParts([profileSV])
    }
}

extension ProfileCardController: SymbolProfileDataDeleagate {
    func updateSymbolProfile(newSymbolProfile: String) {
        do {
            let symbolProfile = try JSONDecoder().decode(SymbolProfile.self, from: newSymbolProfile.data(using: .utf8)!)
            exchangeData.text = symbolProfile.exchange
            
            if symbolProfile.country != nil {
                countryData.text = symbolProfile.country!
            } else {
                countryData.text = "-"
            }
            
            if symbolProfile.industry != nil {
                industryData.text = symbolProfile.industry!
            } else {
                countryData.text = "-"
            }
            
            if symbolProfile.sector != nil {
                sectorData.text = symbolProfile.sector!
            } else {
                countryData.text = "-"
            }
            
            if symbolProfile.isin != nil {
                isinData.text = symbolProfile.isin!
            } else {
                countryData.text = "-"
            }
        } catch {
            print("Failed to decode company details!")
        }
    }
}

extension ProfileCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

extension ProfileCardController: GradientCardTrait {
    func gradientColors() -> [UIColor] {
        
        let color1: UIColor = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        var color2: UIColor = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        
        while color1 == color2 {
            color2 = self.possibleGradientColors[Int(arc4random_uniform(UInt32(self.possibleGradientColors.count)))]
        }
        
        return [color1, color2]
    }
    
    func gradientAngle() -> Float {
        return 45.0
    }
}

extension ProfileCardController: TransparentCardTrait {
    func requiresTransparentCard() -> Bool {
        true
    }
}
