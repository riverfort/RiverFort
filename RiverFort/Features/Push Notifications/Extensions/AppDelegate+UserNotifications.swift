//
//  AppDelegate+UserNotifications.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 04/10/2021.
//

import UIKit
import UserNotifications
import SafariServices

// MARK: - Config User Notifications

extension AppDelegate {
    func configUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
    }
}

// MARK: - Asking for User Notifications Permission

extension AppDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("User Notifications permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

// MARK: - Registering With APNs

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.deviceToken = token
        PushNotificationsAPIFunction.syncDeviceToken(deviceToken: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let link = userInfo["link"] as? String else { return }
        guard let url = URL(string: link) else { return }
        let vc = SFSafariViewController(url: url)
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        completionHandler()
    }
}
