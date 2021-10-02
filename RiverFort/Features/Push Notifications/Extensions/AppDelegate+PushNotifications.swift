//
//  AppDelegate+PushNotifications.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import UIKit

extension AppDelegate {
    public func configPushNotification(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UNUserNotificationCenter.current().delegate = self
        PushNotifications.registerForPushNotifications()
        PushNotifications.handleLaunchFromNotification(didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        PushNotificationsAPIFunction.syncDeviceToken(deviceToken: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notification: \(error)")
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else { completionHandler(.failed); return }
        print("didReceiveRemoteNotification: \(aps)")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if response.actionIdentifier == "view_notification" { print("view_notification: \(aps)") }
        }
        completionHandler()
    }
}
