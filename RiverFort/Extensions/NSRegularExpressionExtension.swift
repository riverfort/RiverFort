//
//  NSRegularExpressionExtension.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 13/05/2021.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
