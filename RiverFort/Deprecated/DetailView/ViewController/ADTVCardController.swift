//
//  ADTVCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 08/05/2021.
//

import Foundation
import CardParts

class ADTVCardController: CardPartsViewController {
    
    let possibleGradientColors: [UIColor] = [
        UIColor(red: 179.0 / 255.0, green: 205.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.3),
        UIColor(red: 204.0 / 255.0, green: 230.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.3),
    ]
    
    private var company: Company
    
    var stackViews: [CardPartStackView] = []
    let adtvsSV  = CardPartStackView()
    let aadtvsSV = CardPartStackView()
    
    let adtv1SV   = CardPartStackView()
    let adtv5SV   = CardPartStackView()
    let adtv10SV  = CardPartStackView()
    let adtv20SV  = CardPartStackView()
    let adtv60SV  = CardPartStackView()
    let adtv120SV = CardPartStackView()
    
    let aadtv1SV   = CardPartStackView()
    let aadtv5SV   = CardPartStackView()
    let aadtv10SV  = CardPartStackView()
    let aadtv20SV  = CardPartStackView()
    let aadtv60SV  = CardPartStackView()
    let aadtv120SV = CardPartStackView()
    
    let adtvsText  = CardPartTextView(type: .title)
    let aadtvsText = CardPartTextView(type: .title)
    
    let adtv1Text   = CardPartTextView(type: .normal)
    let adtv5Text   = CardPartTextView(type: .normal)
    let adtv10Text  = CardPartTextView(type: .normal)
    let adtv20Text  = CardPartTextView(type: .normal)
    let adtv60Text  = CardPartTextView(type: .normal)
    let adtv120Text = CardPartTextView(type: .normal)
    
    let adtv1Data   = CardPartTextView(type: .normal)
    let adtv5Data   = CardPartTextView(type: .normal)
    let adtv10Data  = CardPartTextView(type: .normal)
    let adtv20Data  = CardPartTextView(type: .normal)
    let adtv60Data  = CardPartTextView(type: .normal)
    let adtv120Data = CardPartTextView(type: .normal)
    
    let aadtv1Text   = CardPartTextView(type: .normal)
    let aadtv5Text   = CardPartTextView(type: .normal)
    let aadtv10Text  = CardPartTextView(type: .normal)
    let aadtv20Text  = CardPartTextView(type: .normal)
    let aadtv60Text  = CardPartTextView(type: .normal)
    let aadtv120Text = CardPartTextView(type: .normal)
    
    let aadtv1Data   = CardPartTextView(type: .normal)
    let aadtv5Data   = CardPartTextView(type: .normal)
    let aadtv10Data  = CardPartTextView(type: .normal)
    let aadtv20Data  = CardPartTextView(type: .normal)
    let aadtv60Data  = CardPartTextView(type: .normal)
    let aadtv120Data = CardPartTextView(type: .normal)
    
    init(company: Company) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
        APIFunctions.functions.recentADTVDelegate = self
        APIFunctions.functions.fetchRecentADTV(companyTicker: company.company_ticker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        adtvsText.text  = "ADTV"
        aadtvsText.text = "AADTV"
        adtvsText.font  = UIFont(name: "AvenirNext-Bold", size: 16.0)
        aadtvsText.font = UIFont(name: "AvenirNext-Bold", size: 16.0)
        adtvsText.textColor  = .label
        aadtvsText.textColor = .label
    
        stackViews.append(adtvsSV)
        stackViews.append(aadtvsSV)
        
        adtvsSV.axis = .vertical
        adtvsSV.distribution = .equalSpacing
        adtvsSV.spacing = 5
        adtvsSV.addArrangedSubview(adtvsText)
        adtvsSV.addArrangedSubview(adtv1SV)
        adtvsSV.addArrangedSubview(CardPartSeparatorView())
        adtvsSV.addArrangedSubview(adtv5SV)
        adtvsSV.addArrangedSubview(CardPartSeparatorView())
        adtvsSV.addArrangedSubview(adtv10SV)
        adtvsSV.addArrangedSubview(CardPartSeparatorView())
        adtvsSV.addArrangedSubview(adtv20SV)
        adtvsSV.addArrangedSubview(CardPartSeparatorView())
        adtvsSV.addArrangedSubview(adtv60SV)
        adtvsSV.addArrangedSubview(CardPartSeparatorView())
        adtvsSV.addArrangedSubview(adtv120SV)
        
        aadtvsSV.axis = .vertical
        aadtvsSV.distribution = .equalSpacing
        aadtvsSV.spacing = 5
        aadtvsSV.addArrangedSubview(aadtvsText)
        aadtvsSV.addArrangedSubview(aadtv1SV)
        aadtvsSV.addArrangedSubview(CardPartSeparatorView())
        aadtvsSV.addArrangedSubview(aadtv5SV)
        aadtvsSV.addArrangedSubview(CardPartSeparatorView())
        aadtvsSV.addArrangedSubview(aadtv10SV)
        aadtvsSV.addArrangedSubview(CardPartSeparatorView())
        aadtvsSV.addArrangedSubview(aadtv20SV)
        aadtvsSV.addArrangedSubview(CardPartSeparatorView())
        aadtvsSV.addArrangedSubview(aadtv60SV)
        aadtvsSV.addArrangedSubview(CardPartSeparatorView())
        aadtvsSV.addArrangedSubview(aadtv120SV)
        
        adtv1SV.axis = .horizontal
        adtv1SV.distribution = .equalSpacing
        adtv1SV.addArrangedSubview(adtv1Text)
        adtv1SV.addArrangedSubview(adtv1Data)
        
        adtv5SV.axis = .horizontal
        adtv5SV.distribution = .equalSpacing
        adtv5SV.addArrangedSubview(adtv5Text)
        adtv5SV.addArrangedSubview(adtv5Data)
        
        adtv10SV.axis = .horizontal
        adtv10SV.distribution = .equalSpacing
        adtv10SV.addArrangedSubview(adtv10Text)
        adtv10SV.addArrangedSubview(adtv10Data)
        
        adtv20SV.axis = .horizontal
        adtv20SV.distribution = .equalSpacing
        adtv20SV.addArrangedSubview(adtv20Text)
        adtv20SV.addArrangedSubview(adtv20Data)
        
        adtv60SV.axis = .horizontal
        adtv60SV.distribution = .equalSpacing
        adtv60SV.addArrangedSubview(adtv60Text)
        adtv60SV.addArrangedSubview(adtv60Data)
        
        adtv120SV.axis = .horizontal
        adtv120SV.distribution = .equalSpacing
        adtv120SV.addArrangedSubview(adtv120Text)
        adtv120SV.addArrangedSubview(adtv120Data)
        
        aadtv1SV.axis = .horizontal
        aadtv1SV.distribution = .equalSpacing
        aadtv1SV.addArrangedSubview(aadtv1Text)
        aadtv1SV.addArrangedSubview(aadtv1Data)
        
        aadtv5SV.axis = .horizontal
        aadtv5SV.distribution = .equalSpacing
        aadtv5SV.addArrangedSubview(aadtv5Text)
        aadtv5SV.addArrangedSubview(aadtv5Data)
        
        aadtv10SV.axis = .horizontal
        aadtv10SV.distribution = .equalSpacing
        aadtv10SV.addArrangedSubview(aadtv10Text)
        aadtv10SV.addArrangedSubview(aadtv10Data)
        
        aadtv20SV.axis = .horizontal
        aadtv20SV.distribution = .equalSpacing
        aadtv20SV.addArrangedSubview(aadtv20Text)
        aadtv20SV.addArrangedSubview(aadtv20Data)
        
        aadtv60SV.axis = .horizontal
        aadtv60SV.distribution = .equalSpacing
        aadtv60SV.addArrangedSubview(aadtv60Text)
        aadtv60SV.addArrangedSubview(aadtv60Data)
        
        aadtv120SV.axis = .horizontal
        aadtv120SV.distribution = .equalSpacing
        aadtv120SV.addArrangedSubview(aadtv120Text)
        aadtv120SV.addArrangedSubview(aadtv120Data)
        
        adtv1Text.text   = "1"
        adtv5Text.text   = "5"
        adtv10Text.text  = "10"
        adtv20Text.text  = "20"
        adtv60Text.text  = "60"
        adtv120Text.text = "120"
        
        aadtv1Text.text   = "1"
        aadtv5Text.text   = "5"
        aadtv10Text.text  = "10"
        aadtv20Text.text  = "20"
        aadtv60Text.text  = "60"
        aadtv120Text.text = "120"
        
        adtv1Data.text    = "-"
        adtv5Data.text    = "-"
        adtv10Data.text   = "-"
        adtv20Data.text   = "-"
        adtv60Data.text   = "-"
        adtv120Data.text  = "-"
        
        aadtv1Data.text   = "-"
        aadtv5Data.text   = "-"
        aadtv10Data.text  = "-"
        aadtv20Data.text  = "-"
        aadtv60Data.text  = "-"
        aadtv120Data.text = "-"

        adtv1Text.font = .preferredFont(forTextStyle: .subheadline)
        adtv5Text.font = .preferredFont(forTextStyle: .subheadline)
        adtv10Text.font  = .preferredFont(forTextStyle: .subheadline)
        adtv20Text.font  = .preferredFont(forTextStyle: .subheadline)
        adtv60Text.font  = .preferredFont(forTextStyle: .subheadline)
        adtv120Text.font = .preferredFont(forTextStyle: .subheadline)
        
        adtv1Text.label.adjustsFontForContentSizeCategory = true
        adtv5Text.label.adjustsFontForContentSizeCategory = true
        adtv10Text.label.adjustsFontForContentSizeCategory = true
        adtv20Text.label.adjustsFontForContentSizeCategory = true
        adtv60Text.label.adjustsFontForContentSizeCategory = true
        adtv120Text.label.adjustsFontForContentSizeCategory = true
        
        aadtv1Text.font = .preferredFont(forTextStyle: .subheadline)
        aadtv5Text.font = .preferredFont(forTextStyle: .subheadline)
        aadtv10Text.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv20Text.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv60Text.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv120Text.font = .preferredFont(forTextStyle: .subheadline)
        
        aadtv1Text.label.adjustsFontForContentSizeCategory = true
        aadtv5Text.label.adjustsFontForContentSizeCategory = true
        aadtv10Text.label.adjustsFontForContentSizeCategory = true
        aadtv20Text.label.adjustsFontForContentSizeCategory = true
        aadtv60Text.label.adjustsFontForContentSizeCategory = true
        aadtv120Text.label.adjustsFontForContentSizeCategory = true
        
        adtv1Data.font = .preferredFont(forTextStyle: .subheadline)
        adtv5Data.font = .preferredFont(forTextStyle: .subheadline)
        adtv10Data.font  = .preferredFont(forTextStyle: .subheadline)
        adtv20Data.font  = .preferredFont(forTextStyle: .subheadline)
        adtv60Data.font  = .preferredFont(forTextStyle: .subheadline)
        adtv120Data.font = .preferredFont(forTextStyle: .subheadline)
        
        adtv1Data.label.adjustsFontForContentSizeCategory = true
        adtv5Data.label.adjustsFontForContentSizeCategory = true
        adtv10Data.label.adjustsFontForContentSizeCategory = true
        adtv20Data.label.adjustsFontForContentSizeCategory = true
        adtv60Data.label.adjustsFontForContentSizeCategory = true
        adtv120Data.label.adjustsFontForContentSizeCategory = true
        
        aadtv1Data.font = .preferredFont(forTextStyle: .subheadline)
        aadtv5Data.font = .preferredFont(forTextStyle: .subheadline)
        aadtv10Data.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv20Data.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv60Data.font  = .preferredFont(forTextStyle: .subheadline)
        aadtv120Data.font = .preferredFont(forTextStyle: .subheadline)
        
        aadtv1Data.label.adjustsFontForContentSizeCategory = true
        aadtv5Data.label.adjustsFontForContentSizeCategory = true
        aadtv10Data.label.adjustsFontForContentSizeCategory = true
        aadtv20Data.label.adjustsFontForContentSizeCategory = true
        aadtv60Data.label.adjustsFontForContentSizeCategory = true
        aadtv120Data.label.adjustsFontForContentSizeCategory = true
        
        adtv1Text.textColor = .label
        adtv5Text.textColor = .label
        adtv10Text.textColor  = .label
        adtv20Text.textColor  = .label
        adtv60Text.textColor  = .label
        adtv120Text.textColor = .label
        
        adtv1Data.textColor = .label
        adtv5Data.textColor = .label
        adtv10Data.textColor  = .label
        adtv20Data.textColor  = .label
        adtv60Data.textColor  = .label
        adtv120Data.textColor = .label
        
        aadtv1Text.textColor = .label
        aadtv5Text.textColor = .label
        aadtv10Text.textColor  = .label
        aadtv20Text.textColor  = .label
        aadtv60Text.textColor  = .label
        aadtv120Text.textColor = .label
        
        aadtv1Data.textColor = .label
        aadtv5Data.textColor = .label
        aadtv10Data.textColor  = .label
        aadtv20Data.textColor  = .label
        aadtv60Data.textColor  = .label
        aadtv120Data.textColor = .label
        
        let cardPartPagedView = CardPartPagedView(withPages: stackViews, andHeight: 200)
        cardPartPagedView.margins = UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
        setupCardParts([cardPartPagedView])
    }
}

extension ADTVCardController: RecentADTVDataDeleagate {
    func updateRecentADTV(newRecentADTV: String) {
        do {
            let recentADTV = try JSONDecoder().decode(ADTV.self, from: newRecentADTV.data(using: .utf8)!)
            
                adtv1Data.text    = round(recentADTV.adtv).withCommas()
                adtv5Data.text    = round(recentADTV.adtv5).withCommas()
                adtv10Data.text   = round(recentADTV.adtv10).withCommas()
                adtv20Data.text   = round(recentADTV.adtv20).withCommas()
                adtv60Data.text   = round(recentADTV.adtv60).withCommas()
                adtv120Data.text  = round(recentADTV.adtv120).withCommas()
                
                aadtv5Data.text   = round(Double(recentADTV.aadtv5)!).withCommas()
                aadtv10Data.text  = round(Double(recentADTV.aadtv10)!).withCommas()
                aadtv20Data.text  = round(Double(recentADTV.aadtv20)!).withCommas()
                aadtv60Data.text  = round(Double(recentADTV.aadtv60)!).withCommas()
                aadtv120Data.text = round(Double(recentADTV.aadtv120)!).withCommas()
                
                if recentADTV.aadtv != nil {
                    aadtv1Data.text = round(recentADTV.aadtv!).withCommas()
                } else {
                    aadtv1Data.text = "-"
                }
        } catch {
            print("Failed to decode company details!")
        }
    }
}

extension ADTVCardController: RoundedCardTrait {
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

extension ADTVCardController: GradientCardTrait {
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

extension ADTVCardController: TransparentCardTrait {
    func requiresTransparentCard() -> Bool {
        true
    }
}
