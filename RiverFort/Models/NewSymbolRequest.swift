//
//  NewSymbolRequest.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 12/05/2021.
//

import Foundation

struct NewSymbolRequest: Encodable {
    var company: String
    var time: String
}

struct AddOnSymbolRequest: Encodable {
    let company_ticker: String
    let company_name: String
}
