//
//  AppVersion.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 28/04/2021.
//

import Foundation

struct AppVersion {
    
    static let kVersion     = "CFBundleShortVersionString"
    static let kBuildNumber = "CFBundleVersion"
    
    static func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version    = dictionary[kVersion] as! String
        let build      = dictionary[kBuildNumber] as! String
        
        return "Version \(version) (\(build))"
    }
}
