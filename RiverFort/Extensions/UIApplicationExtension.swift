//
//  UIApplicationExtension.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 15/09/2021.
//

import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard var top = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
