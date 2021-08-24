//
//  UIApplication+notification.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/08/2021.
//

import Foundation
import UserNotifications

class NotificationHelper {
    static let isRegisteredForRemoteNotificationsLogs = isRegisteredForRemoteNotifications() ? "On" : "Off"
    
    static func isRegisteredForRemoteNotifications() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
}
