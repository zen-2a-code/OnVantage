//
//  ChallengeDetailsViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 14.05.26.
//

import Foundation
import SwiftData
import SwiftUI

extension ChallengeDetailsView {
    @Observable
    class ViewModel {
        let challenge: Challenge
        var modelContext: ModelContext
        var onNavigateBackToHomeScreen: () -> Void
        var showCycleCompleteSheet: Bool = false

        init(
            challenge: Challenge,
            modelContext: ModelContext,
            onNavigateBackToHomeScreen: @escaping () -> Void
        ) {
            self.challenge = challenge
            self.modelContext = modelContext
            self.onNavigateBackToHomeScreen = onNavigateBackToHomeScreen

        }

        func markComplete() {
            let attemptRecord = ChallengeAttempt(
                startedAt: .now,
                status: .completed,
                challenge: challenge
            )
            challenge.attempts.append(attemptRecord)
            modelContext.insert(attemptRecord)

            if let progress = challenge.category.progress {
                StreakCalculator.recordCompletion(for: progress)
                try? modelContext.save()
                showCycleCompleteSheet = CycleManager.checkCycleCompletion(
                    for: progress
                )
            }
        }

        func restartCycle() {
            if let progress = challenge.category.progress {
                CycleManager.startNewCycle(for: progress)
                try? modelContext.save()
                onNavigateBackToHomeScreen()
            }
        }

        func archiveCategory() {
            if let progress = challenge.category.progress {
                CycleManager.startNewCycle(for: progress)
                try? modelContext.save()
                challenge.category.isActive = false
                try? modelContext.save()
                onNavigateBackToHomeScreen()
            }
        }

        func deleteCategory() {
            modelContext.delete(challenge.category)
            try? modelContext.save()
            onNavigateBackToHomeScreen()
        }
    }
}
