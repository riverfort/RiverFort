//
//  QuotesCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/05/2021.
//

import Foundation
import CardParts

struct CompanyMktCap: Decodable {
    let market_cap: Double?
}

class QuotesCardController: CardPartsViewController {
    
    let possibleGradientColors: [UIColor] = [
        UIColor(red: 179.0 / 255.0, green: 205.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.3),
        UIColor(red: 204.0 / 255.0, green: 230.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.3),
    ]
    
    private var company: Company
    
    let quoteSV  = CardPartStackView()
    let mktcapSV = CardPartStackView()
    let volumeSV = CardPartStackView()
    let vwapSV   = CardPartStackView()
    let openSV   = CardPartStackView()
    let closeSV  = CardPartStackView()
    let highSV   = CardPartStackView()
    let lowSV    = CardPartStackView()
    
    let ocSV     = CardPartStackView()
    let hlSV     = CardPartStackView()
    
    let mktcapText = CardPartTextView(type: .normal)
    let volumeText = CardPartTextView(type: .normal)
    let vwapText   = CardPartTextView(type: .normal)
    let openText   = CardPartTextView(type: .normal)
    let closeText  = CardPartTextView(type: .normal)
    let highText   = CardPartTextView(type: .normal)
    let lowText    = CardPartTextView(type: .normal)
    
    let mktDateData = CardPartTextView(type: .title)
    let mktcapData = CardPartTextView(type: .normal)
    let volumeData = CardPartTextView(type: .normal)
    let vwapData   = CardPartTextView(type: .normal)
    let openData   = CardPartTextView(type: .normal)
    let closeData  = CardPartTextView(type: .normal)
    let highData   = CardPartTextView(type: .normal)
    let lowData    = CardPartTextView(type: .normal)
    
    init(company: Company) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
//        APIFunctions.functions.quoteDeleagate = self
//        APIFunctions.functions.fetchQuote(companyTicker: company.company_ticker)
        
        APIFunctions.functions.companyTradingQuoteDelegate = self
        APIFunctions.functions.fetchCompanyTradingQuote(companyTicker: company.company_ticker)
        
        APIFunctions.functions.companyMktCapDelegate = self
        APIFunctions.functions.fetchCompanyMktCap(companyTicker: company.company_ticker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mktcapText.text = "Mkt Cap"
        volumeText.text = "Trading Volume"
        vwapText.text   = "VWAP"
        openText.text   = "Open"
        closeText.text  = "Close"
        highText.text   = "High"
        lowText.text    = "Low"
        
        mktcapText.font = UIFont(name: "Avenir-Medium", size: 14.0)
        volumeText.font = UIFont(name: "Avenir-Medium", size: 14.0)
        vwapText.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        openText.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        closeText.font  = UIFont(name: "Avenir-Medium", size: 14.0)
        highText.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        lowText.font    = UIFont(name: "Avenir-Medium", size: 14.0)
        
        mktDateData.font = UIFont(name: "AvenirNext-Bold", size: 16.0)
        mktcapData.font = UIFont(name: "Avenir-Medium", size: 14.0)
        volumeData.font = UIFont(name: "Avenir-Medium", size: 14.0)
        vwapData.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        openData.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        closeData.font  = UIFont(name: "Avenir-Medium", size: 14.0)
        highData.font   = UIFont(name: "Avenir-Medium", size: 14.0)
        lowData.font    = UIFont(name: "Avenir-Medium", size: 14.0)
        
        mktDateData.textAlignment = .left
                
        mktcapText.textColor = .label
        volumeText.textColor = .label
        vwapText.textColor   = .label
        openText.textColor   = .label
        closeText.textColor  = .label
        highText.textColor   = .label
        lowText.textColor    = .label
        
        mktDateData.textColor = .label
        mktcapData.textColor = .label
        volumeData.textColor = .label
        vwapData.textColor   = .label
        openData.textColor   = .label
        closeData.textColor  = .label
        highData.textColor   = .label
        lowData.textColor    = .label
        
        mktcapSV.axis = .horizontal
        mktcapSV.distribution = .equalSpacing
        mktcapSV.addArrangedSubview(mktcapText)
        mktcapSV.addArrangedSubview(mktcapData)
        
        volumeSV.axis = .horizontal
        volumeSV.distribution = .equalSpacing
        volumeSV.addArrangedSubview(volumeText)
        volumeSV.addArrangedSubview(volumeData)
        
        vwapSV.axis = .horizontal
        vwapSV.distribution = .equalSpacing
        vwapSV.addArrangedSubview(vwapText)
        vwapSV.addArrangedSubview(vwapData)

        openSV.axis = .horizontal
        openSV.distribution = .equalSpacing
        openSV.addArrangedSubview(openText)
        openSV.addArrangedSubview(openData)
        
        closeSV.axis = .horizontal
        closeSV.distribution = .equalSpacing
        closeSV.addArrangedSubview(closeText)
        closeSV.addArrangedSubview(closeData)
        
        ocSV.axis = .vertical
        ocSV.distribution = .equalSpacing
        ocSV.addArrangedSubview(openSV)
        ocSV.addArrangedSubview(closeSV)
        
        highSV.axis = .horizontal
        highSV.distribution = .equalSpacing
        highSV.addArrangedSubview(highText)
        highSV.addArrangedSubview(highData)
    
        lowSV.axis = .horizontal
        lowSV.distribution = .equalSpacing
        lowSV.addArrangedSubview(lowText)
        lowSV.addArrangedSubview(lowData)
        
        hlSV.axis = .vertical
        hlSV.distribution = .equalSpacing
        hlSV.addArrangedSubview(highSV)
        hlSV.addArrangedSubview(lowSV)

        quoteSV.axis = .vertical
        quoteSV.distribution = .equalSpacing
        quoteSV.spacing = 5
        quoteSV.addArrangedSubview(mktDateData)
        quoteSV.addArrangedSubview(mktcapSV)
        quoteSV.addArrangedSubview(CardPartSeparatorView())
        quoteSV.addArrangedSubview(volumeSV)
        quoteSV.addArrangedSubview(CardPartSeparatorView())
        quoteSV.addArrangedSubview(vwapSV)
        quoteSV.addArrangedSubview(CardPartSeparatorView())
        quoteSV.addArrangedSubview(CardPartCenteredView(leftView: ocSV, centeredView: CardPartVerticalSeparatorView(), rightView: hlSV))

        quoteSV.margins = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
                
        setupCardParts([quoteSV])
    }
}


extension QuotesCardController: CompanyMktCapDataDelegate {
    
    func updateCompanyMktCap(newCompanyMktCap: String) {
        do {
            let companyMktCap = try JSONDecoder().decode(CompanyMktCap.self, from: newCompanyMktCap.data(using: .utf8)!)
                        
            if companyMktCap.market_cap != nil {
//                if quoteProfile[0].currency == "" {
//                    mktcapData.text = String(companyMktCap.market_cap!.withCommas())
//                } else {
                    mktcapData.text = String(companyMktCap.market_cap!.withCommas())
//                }
            } else {
                mktcapData.text = "-"
            }
        } catch {
            print("Failed to decode company mkt cap!")
        }
    }
}


extension QuotesCardController: CompanyTradingQuoteDataDelegate {
    
    func updateCompanyTradingQuote(newCompanyTradingQuote: String) {
        do {
            let companyTradingQuote = try JSONDecoder().decode(CompanyTradingQuote.self, from: newCompanyTradingQuote.data(using: .utf8)!)
            
            mktDateData.text = DateFormatterUtils.convertDateFormater(companyTradingQuote.market_date)
            
            volumeData.text = companyTradingQuote.volume.withCommas()
            
            if companyTradingQuote.vwap != nil {
                vwapData.text = String(format: "%.2f", companyTradingQuote.vwap!)
            } else {
                vwapData.text = "-"
            }
            
            openData.text  = String(companyTradingQuote.open)
            closeData.text = String(companyTradingQuote.close)
            highData.text  = String(companyTradingQuote.high)
            lowData.text   = String(companyTradingQuote.low)

        } catch {
            print("Failed to decode company trading quote!")
        }
    }
}


//extension QuotesCardController: QuoteDataDeleagate {
//    func updateQuote(newQuote: String) {
//        do {
//            let quoteProfile = try JSONDecoder().decode([Quote].self, from: newQuote.data(using: .utf8)!)
//
//            mktDateData.text = DateFormatterUtils.convertDateFormater(quoteProfile[0].market_date)
//
//            if quoteProfile[0].market_cap != nil {
//                if quoteProfile[0].currency == "" {
//                    mktcapData.text = String(quoteProfile[0].market_cap!.withCommas())
//                } else {
//                    mktcapData.text = Currency.getSymbol(forCurrencyCode: quoteProfile[0].currency)! + String(quoteProfile[0].market_cap!.withCommas())
//                }
//            } else {
//                mktcapData.text = "-"
//            }
//
//            volumeData.text = quoteProfile[0].volume.withCommas()
//
//            if quoteProfile[0].vwap != nil {
//                vwapData.text = quoteProfile[0].currency + String(format: "%.2f", quoteProfile[0].vwap!)
//            } else {
//                vwapData.text = "-"
//            }
//
//            openData.text  = String(quoteProfile[0].open)
//            closeData.text = String(quoteProfile[0].close)
//            highData.text  = String(quoteProfile[0].high)
//            lowData.text   = String(quoteProfile[0].low)
//
//        } catch {
//            print("Failed to decode company details!")
//        }
//    }
//}

extension QuotesCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

extension QuotesCardController: GradientCardTrait {
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

extension QuotesCardController: TransparentCardTrait {
    func requiresTransparentCard() -> Bool {
        true
    }
}
