//
//  LogGenerator.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/08/2021.
//

import Foundation

class LogGenerator {
    static var LOG_SUBMISSION_ALERT_TITLE   = "Log Submission"
    static var LOG_SUBMISSION_ALERT_MESSAGE =
        """
        Would you like to include debugging logs with yout support ticket?
        
        Note that logs do not include personally identifiable information (PII).
        """
    static var LOG =
        """
        \n\n\n
        ---
        Device Type: \(UIDevice.modelName)
        System Version: \(UIDevice.current.systemVersion)
        App Version: \(UIApplication.version)
        Notification: \(NotificationHelper.isRegisteredForRemoteNotificationsLogs)
        Device Token: \(UserDefaults.standard.string(forKey: "deviceToken") ?? "-")
        ---
        """
}
