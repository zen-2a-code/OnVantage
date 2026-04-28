//
//  OnVantageApp.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import SwiftUI

@main
struct OnVantageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Category.self,
            CategoryProgress.self,
            Challenge.self,
            ChallengeAttempt.self,
        ])
    }
}
