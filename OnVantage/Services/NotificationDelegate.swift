//
//  NotificationDelegate.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import Foundation
@preconcurrency import UserNotifications

/// Handles notification presentation and tap actions.
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    var deepLinkHandler: DeepLinkHandler?

    /// Shows notification banners even when the app is in the foreground.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    /// Called when the user taps a notification. Extracts the category ID
    /// and sets it on DeepLinkHandler so HomeView can navigate to the challenge.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let categoryIdString = userInfo["categoryId"] as? String,
            let categoryId = UUID(uuidString: categoryIdString)
        {
            DispatchQueue.main.async {
                self.deepLinkHandler?.selectedTab = 0
                self.deepLinkHandler?.pendingCategoryId = categoryId
            }
        }

        completionHandler()
    }
}
