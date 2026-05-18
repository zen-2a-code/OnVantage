//
//  HomeViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 17.05.26.
//

internal import Combine
import SwiftData
import SwiftUI

extension HomeView {
    @Observable
    class ViewModel {
        let hourglassRotationTimer = Timer.publish(
            every: 3,
            on: .main,
            in: .common
        )
        .autoconnect()
        let countDownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()

        var timeUntilTomorrow: String = "23 hours, 59 minutes, 59 seconds"
        var hourGlassRotationAngle: Double = 0.0
        var navigationPath = NavigationPath()
        var modelContext: ModelContext

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func sortedActiveCategories(from categories: [ChallengeCategory]) -> [ChallengeCategory] {
            categories.filter { $0.isActive }.sorted { a, b in
                let dateA = a.progress?.lastActivityDate ?? .distantPast
                let dateB = b.progress?.lastActivityDate ?? .distantPast
                return dateA < dateB
            }
        }

        func tickCountdown() {
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfTomorrow = calendar.date(
                byAdding: .day,
                value: 1,
                to: startOfToday
            )!

            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .full

            timeUntilTomorrow =
                formatter.string(from: .now, to: startOfTomorrow)
                ?? "Unknown time"
        }

        func tickHourglass() {
            hourGlassRotationAngle = hourGlassRotationAngle == 0 ? 180 : 0
        }

        func nextChallenge(for category: ChallengeCategory) -> Challenge? {
            if let progres = category.progress {
                let pickerResult = ChallengeProvider.nextChallenge(for: progres)

                if case .challenge(let challenge) = pickerResult {
                    return challenge
                }
            }
            return nil
        }

        func statusText(for category: ChallengeCategory) -> String {
            if let progress = category.progress {
                if ChallengeProvider.nextChallenge(for: progress)
                    == .doneForToday
                {
                    return "This category challenges are done for today!"
                } else if ChallengeProvider.nextChallenge(for: progress)
                    == .empty
                {
                    return "No challenges for this category"
                } else {
                    return timeUntilTomorrow
                }
            }
            return ""
        }

        func hasChallengeToday(for category: ChallengeCategory) -> Bool {
            guard let progress = category.progress else { return false }
            if case .challenge = ChallengeProvider.nextChallenge(for: progress)
            {
                return true
            }
            return false
        }

        func skip(for category: ChallengeCategory, challenge: Challenge) {
            guard let progress = category.progress else { return }
            guard progress.skipsRemainingThisCycle > 0 else { return }
            StreakCalculator.recordSkip(for: progress)
            let skipAttempt = ChallengeAttempt(startedAt: .now, status: .skipped, challenge: challenge)
            challenge.attempts.append(skipAttempt)
            modelContext.insert(skipAttempt)
            try? modelContext.save()
        }

        func clearNavigation() {
            navigationPath = NavigationPath()
        }
    }
}
