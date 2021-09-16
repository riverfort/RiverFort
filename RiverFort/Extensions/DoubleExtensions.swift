//
//  DoubleExtension.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/04/2021.
//

import Foundation

extension Double {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
