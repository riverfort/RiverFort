//
//  DateFormatterUtils.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/04/2021.
//

import Foundation

struct DateFormatterUtils {
    
    static func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return  dateFormatter.string(from: date!)
    }
        
    static func convertDateFormate_MY(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM yy"
        return  dateFormatter.string(from: date!).replacingOccurrences(of: " ", with: "'", options: .literal, range: nil)
    }
    
    static func convertDateFormate_DM(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM"
        return  dateFormatter.string(from: date!)
    }
    
    static func convertDateFormate_DMY_YMD(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }
}
