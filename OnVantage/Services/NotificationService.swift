//
//  NotificationService.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import Foundation
@preconcurrency import UserNotifications

/// Handles scheduling and canceling local daily notifications per category.
enum NotificationService {

    private static let center = UNUserNotificationCenter.current()

    // MARK: - Permission

    static func authorizationStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    static func requestPermission() async -> Bool {
        (try? await center.requestAuthorization(options: [.alert, .badge, .sound])) ?? false
    }

    // MARK: - Scheduling

    /// Schedules a daily repeating notification for a category.
    /// Checks/requests permission automatically.
    /// Returns false if permission was denied — caller can show an alert.
    @discardableResult
    static func schedule(
        categoryId: UUID,
        categoryName: String,
        hour: Int,
        minute: Int
    ) async -> Bool {
        var status = await authorizationStatus()

        if status == .notDetermined {
            let granted = await requestPermission()
            status = granted ? .authorized : .denied
        }

        guard status == .authorized || status == .provisional else {
            return false
        }

        cancel(categoryId: categoryId)

        let content = UNMutableNotificationContent()
        content.title = categoryName
        content.body = "Time for your \(categoryName) daily challenge!"
        content.sound = .default
        content.userInfo = ["categoryId": categoryId.uuidString]

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: notificationId(for: categoryId),
            content: content,
            trigger: trigger
        )

        try? await center.add(request)
        return true
    }

    // MARK: - Canceling

    static func cancel(categoryId: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: [notificationId(for: categoryId)]
        )
    }

    // MARK: - Helpers

    private static func notificationId(for categoryId: UUID) -> String {
        "onvantage.daily.\(categoryId.uuidString)"
    }
}
