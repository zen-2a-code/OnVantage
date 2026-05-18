//
//  OnVantageApp.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import SwiftUI
@preconcurrency import UserNotifications

@main
struct OnVantageApp: App {
    private let deepLinkHandler = DeepLinkHandler()
    private let notificationDelegate = NotificationDelegate()

    init() {
        notificationDelegate.deepLinkHandler = deepLinkHandler
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(deepLinkHandler)
        }
        .modelContainer(for: [
            ChallengeCategory.self,
            CategoryProgress.self,
            Challenge.self,
            ChallengeAttempt.self,
        ])
    }
}
