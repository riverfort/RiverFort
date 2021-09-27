//
//  PushNotifications.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import Foundation
import UserNotifications

class PushNotifications {
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            getNotificationSettings()
          }
    }
    
    static func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
}
