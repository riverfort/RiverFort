//
//  NumberShortScale.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/08/2021.
//

import Foundation

class NumberShortScale {
    public static func formatNumber(_ n: Double) -> String {
        let num = abs(n)
        let sign = (n < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            var formatted = num / 1_000_000_000_000
            formatted = formatted.reduceScale(to: 2)
            return "\(sign)\(formatted)T"
        
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 2)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 2)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 2)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"
        }
    }
}
