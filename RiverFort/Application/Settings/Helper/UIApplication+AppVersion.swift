//
//  UIApplication+AppVersion.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/08/2021.
//

import Foundation

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
