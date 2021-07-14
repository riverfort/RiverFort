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
        AF.request("https://data.riverfort.com/api/v1/companies?fields=company_ticker%2Ccompany_name&ordering=company_name").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.fullListDataDelegate?.updateCompaniesArray(newArray: data!)
        }
    }
    
//    func fetchCompanyDetail(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/company-detail/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.companyDetailDeleagate?.updateCompanyDetail(newCompanyDetail: data!)
//        }
//    }
    
    func fetchCompanyDetail(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/company/\(companyTicker)/quote").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyDetailDeleagate?.updateCompanyDetail(newCompanyDetail: data!)
        }
    }
    
    func fetchCompanyTradingQuote(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/trading/quote").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyTradingQuoteDelegate?.updateCompanyTradingQuote(newCompanyTradingQuote: data!)
        }
    }
    
    func fetchCompanyQuote(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/quote").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyQuoteDelegate?.updateCompanyQuote(newCompanyQuote: data!)
        }
    }
    
    func fetchCompanyCurrency(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)?fields=currency").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyCurrencyDelegate?.updateCompanyCurrency(newCompanyCurrency: data!)
        }
    }
    
    func fetchCompanyMktCap(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/LTG.L/quote?fields=market_cap").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyMktCapDelegate?.updateCompanyMktCap(newCompanyMktCap: data!)
        }
    }
    
    func fetchCompanyTrading(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/trading?ordering=market_date").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.companyTradingDeleagate?.updateCompanyTrading(newCompanyTrading: data!)
        }
    }
    
    func fetchCompanyAdtv20_Adtv60(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv?fields=company_ticker%2Cdate%2Cadtv20&ordering=date").response { response in
            let adtv20Data = String(data: response.data!, encoding: .utf8)
            AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv?fields=company_ticker%2Cdate%2Cadtv60&ordering=date").response { response in
                let adtv60Data = String(data: response.data!, encoding: .utf8)
                self.companyAdtv20_Adtv60Deleagate?.updateCompanyAdtv20_Adtv60(newCompanyAdtv20: adtv20Data!, newCompanyAdtv60: adtv60Data!)
            }
        }
    }
    
    func fetchSymbolProfile(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.symbolProfileDeleagate?.updateSymbolProfile(newSymbolProfile: data!)
        }
    }
    
//    func fetchQuote(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/v2/quote/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.quoteDeleagate?.updateQuote(newQuote: data!)
//        }
//    }
    
    func fetchRecentADTV(companyTicker: String) {
        AF.request("https://data.riverfort.com/api/v1/companies/\(companyTicker)/adtv/quote").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            self.recentADTVDelegate?.updateRecentADTV(newRecentADTV: data!)
        }
    }
    
    
    func addNewSymbol(addOnSymbolRequest: AddOnSymbolRequest, completion: @escaping (Int) -> ()) {
        AF.request("https://data.riverfort.com/api/v1/add-on",
                   method: .post,
                   parameters: addOnSymbolRequest,
                   encoder: JSONParameterEncoder.default).response {
                    response in
                    completion((response.response?.statusCode)!)
                   }
    }
    
//    func notifyNewSymbol(newSymbolRequest: NewSymbolRequest, completion: @escaping (Int) -> ()) {
//        AF.request("https://api.riverfort.com/notifying/add-company/",
//                   method: .post,
//                   parameters: newSymbolRequest,
//                   encoder: JSONParameterEncoder.default).response {
//                    response in
//                    completion((response.response?.statusCode)!)
//                   }
//    }
    
//    func fetchCompanies() {
//        AF.request("https://api.riverfort.com/reporting/companies-full-list-search/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.fullListDataDelegate?.updateCompaniesArray(newArray: data!)
//        }
//    }
//
//    func fetchCompanyDetail(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/company-detail/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.companyDetailDeleagate?.updateCompanyDetail(newCompanyDetail: data!)
//        }
//    }
//
//    func fetchCompanyTrading(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/trading/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.companyTradingDeleagate?.updateCompanyTrading(newCompanyTrading: data!)
//        }
//    }
//
//    func fetchCompanyAdtv20_Adtv60(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/adtv20/\(companyTicker)/").response { response in
//            let adtv20Data = String(data: response.data!, encoding: .utf8)
//            AF.request("https://api.riverfort.com/reporting/adtv60/\(companyTicker)/").response { response in
//                let adtv60Data = String(data: response.data!, encoding: .utf8)
//                self.companyAdtv20_Adtv60Deleagate?.updateCompanyAdtv20_Adtv60(newCompanyAdtv20: adtv20Data!, newCompanyAdtv60: adtv60Data!)
//            }
//        }
//    }
//
//    func fetchSymbolProfile(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/profile/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.symbolProfileDeleagate?.updateSymbolProfile(newSymbolProfile: data!)
//        }
//    }
//
//    func fetchQuote(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/v2/quote/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.quoteDeleagate?.updateQuote(newQuote: data!)
//        }
//    }
//
//    func fetchRecentADTV(companyTicker: String) {
//        AF.request("https://api.riverfort.com/reporting/v2/recent-adtv-aadtv/\(companyTicker)/").response { response in
//            let data = String(data: response.data!, encoding: .utf8)
//            self.recentADTVDelegate?.updateRecentADTV(newRecentADTV: data!)
//        }
//    }
//
//    func notifyNewSymbol(newSymbolRequest: NewSymbolRequest, completion: @escaping (Int) -> ()) {
//        AF.request("https://api.riverfort.com/notifying/add-company/",
//                   method: .post,
//                   parameters: newSymbolRequest,
//                   encoder: JSONParameterEncoder.default).response {
//                    response in
//                    completion((response.response?.statusCode)!)
//                   }
//    }
}
