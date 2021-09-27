//
//  PushNotifications.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import UIKit
import UserNotifications

class PushNotifications {
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            addNotificationActions()
            getNotificationSettings()
          }
    }
    
    private static func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension PushNotifications {
    private static func addNotificationActions() {
        let viewAction = UNNotificationAction(identifier: "view_notification", title: "View", options: [.foreground])
        let londonCategory = UNNotificationCategory(identifier: "london_exchange", actions: [viewAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([londonCategory])
    }
}

extension PushNotifications {
    static func handleLaunchFromNotification(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject],
           let aps = notification["aps"] as? [String: AnyObject] {
            print("handleLaunchFromNotification: \(aps)")
        }
    }
}
