//
//  LogGenerator.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 24/08/2021.
//

import UIKit

class LogGenerator {
    static var ALERT_TITLE   = "Log Submission"
    static var ALERT_MESSAGE =
        """
        Would you like to include debugging logs with yout support ticket?
        
        Note that logs do not include personally identifiable information (PII).
        """
    static var ACTION_INCLUDE_LOG     = "Include Logs"
    static var ACTION_NOT_INCLUDE_LOG = "Don't Include"
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
    static var FEATURE_REQUEST_EMAIL = "Priority: "
    static var REPORT_AN_ISSUE_EMAIL = "[Include summary of issue here.]"
}
