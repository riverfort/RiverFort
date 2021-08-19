//
//  APIFunctions.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import Foundation
import Alamofire

protocol FullListDataDelegate {
    func updateCompaniesArray(newArray: String)
}

protocol CompanyDetailDataDelegate {
    func updateCompanyDetail(newCompanyDetail: String)
}

protocol CompanyTradingQuoteDataDelegate {
    func updateCompanyTradingQuote(newCompanyTradingQuote: String)
}

protocol CompanyCurrencyDataDelegate {
    func updateCompanyCurrency(newCompanyCurrency: String)
}

protocol CompanyMktCapDataDelegate {
    func updateCompanyMktCap(newCompanyMktCap: String)
}

protocol CompanyQuoteDataDelegate {
    func updateCompanyQuote(newCompanyQuote: String)
}

protocol CompanyTradingDataDeleagate {
    func updateCompanyTrading(newCompanyTrading: String)
}

protocol CompanyAdtv20_Adtv60DataDeleagate {
    func updateCompanyAdtv20_Adtv60(newCompanyAdtv20: String, newCompanyAdtv60: String)
}

protocol SymbolProfileDataDeleagate {
    func updateSymbolProfile(newSymbolProfile: String)
}

protocol QuoteDataDeleagate {
    func updateQuote(newQuote: String)
}

protocol RecentADTVDataDeleagate {
    func updateRecentADTV(newRecentADTV: String)
}

class APIFunctions {
    
    static let functions = APIFunctions()
    
    var fullListDataDelegate: FullListDataDelegate?
    var companyDetailDeleagate: CompanyDetailDataDelegate?
    var companyTradingQuoteDelegate: CompanyTradingQuoteDataDelegate?
    var companyCurrencyDelegate: CompanyCurrencyDataDelegate?
    var companyMktCapDelegate: CompanyMktCapDataDelegate?
    var companyQuoteDelegate: CompanyQuoteDataDelegate?
    
    var companyTradingDeleagate: CompanyTradingDataDeleagate?
    var companyAdtv20_Adtv60Deleagate: CompanyAdtv20_Adtv60DataDeleagate?
    var symbolProfileDeleagate: SymbolProfileDataDeleagate?
    var quoteDeleagate: QuoteDataDeleagate?
    var recentADTVDelegate: RecentADTVDataDeleagate?
    
    func fetchCompanies() {
        AF.request("https://data.riverfort.com/api/v1/companies?fields=company_ticker%2Ccompany_name&ordering=company_name")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.fullListDataDelegate?.updateCompaniesArray(newArray: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
        
    func fetchCompanyDetail(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/company/\(companyTicker)/quote")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyDetailDeleagate?.updateCompanyDetail(newCompanyDetail: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyTradingQuote(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/trading/quote")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyTradingQuoteDelegate?.updateCompanyTradingQuote(newCompanyTradingQuote: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyQuote(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/quote")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyQuoteDelegate?.updateCompanyQuote(newCompanyQuote: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyCurrency(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)?fields=currency")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyCurrencyDelegate?.updateCompanyCurrency(newCompanyCurrency: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyMktCap(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/quote?fields=market_cap")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyMktCapDelegate?.updateCompanyMktCap(newCompanyMktCap: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyTrading(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/trading?ordering=market_date")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.companyTradingDeleagate?.updateCompanyTrading(newCompanyTrading: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchCompanyAdtv20_Adtv60(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv?fields=company_ticker%2Cdate%2Cadtv20&ordering=date")
            .validate()
            .response { response in
                var adtv20Data: String?
                switch response.result {
                case .success(_):
                    adtv20Data = String(data: response.data!, encoding: .utf8)
                case .failure(let error):
                    print(error)
                }
            AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv?fields=company_ticker%2Cdate%2Cadtv60&ordering=date")
                .validate()
                .response { response in
                    switch response.result {
                    case .success(_):
                        let adtv60Data = String(data: response.data!, encoding: .utf8)
                        self.companyAdtv20_Adtv60Deleagate?.updateCompanyAdtv20_Adtv60(newCompanyAdtv20: adtv20Data!, newCompanyAdtv60: adtv60Data!)
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func fetchSymbolProfile(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.symbolProfileDeleagate?.updateSymbolProfile(newSymbolProfile: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
        
    func fetchRecentADTV(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv/quote")
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    let data = String(data: response.data!, encoding: .utf8)
                    self.recentADTVDelegate?.updateRecentADTV(newRecentADTV: data!)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    func addNewSymbol(addOnSymbolRequest: AddOnSymbolRequest, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/api/v1/add-on", method: .post, parameters: addOnSymbolRequest).response { response in
            completion((response.response?.statusCode)!)
        }
    }
}
