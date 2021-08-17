//
//  AppDelegate.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import UIKit
import CoreData
import UserNotifications
import SafariServices

enum Identifiers {
  static let viewAction = "VIEW_IDENTIFIER"
  static let newsCategory = "NEWS_CATEGORY"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RiverFort")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
//            print("Permission granted: \(granted)")
            guard granted else { return }
            // 1
            let viewAction = UNNotificationAction(
              identifier: Identifiers.viewAction,
              title: "View",
              options: [.foreground])

            // 2
            let newsCategory = UNNotificationCategory(
              identifier: Identifiers.newsCategory,
              actions: [viewAction],
              intentIdentifiers: [],
              options: [])

            // 3
            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
//        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
}

extension AppDelegate {
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      WatchlistSync.prepRegisterUserDevice(deviceToken: token)
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register for remote notifications: \(error)")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 1
    let userInfo = response.notification.request.content.userInfo
    // 2
    if let aps = userInfo["aps"] as? [String: AnyObject] {
        (UIApplication.topViewController() as! HomeViewController).selectedIndex = 1
        if let url = URL(string: aps["link"] as! String) {
            let safari = SFSafariViewController(url: url)
            UIApplication.topViewController()?.present(safari, animated: true)
        }
      // 3
      if response.actionIdentifier == Identifiers.viewAction,
         let url = URL(string: aps["link"] as! String) {
        let safari = SFSafariViewController(url: url)
        UIApplication.topViewController()?.present(safari, animated: true)
      }
    }
    // 4
    completionHandler()
  }
}
