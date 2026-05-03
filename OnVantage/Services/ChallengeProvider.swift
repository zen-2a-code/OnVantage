//
//  ChallengeProvider.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 2.05.26.
//

import Foundation

enum ChallengeProvider {
    enum PickerResult: Equatable {
        case doneForToday, empty
        case challenge(Challenge)
    }

    static func nextChallenge(
        for progress: CategoryProgress,
        todayDate: Date = .now
    ) -> PickerResult {
        guard progress.challengeQueueOrder.isEmpty == false else {
            return .empty
        }

        let hasComplatedChallengeToday = progress.category.challenges.contains {
            challenge in
            challenge.attempts.contains { attempt in
                Calendar.current.isDate(
                    attempt.startedAt,
                    inSameDayAs: todayDate
                ) && attempt.status == .completed
            }
        }

        if hasComplatedChallengeToday {
            return .doneForToday
        }

        for uuid in progress.challengeQueueOrder {
            if let challenge = progress.category.challenges.first(where: {
                $0.id == uuid
            }) {
                let hasCompletedThisCycle = challenge.attempts.contains {
                    attempt in
                    attempt.startedAt > progress.cycleStartedAt
                        && attempt.status == .completed
                }

                if !hasCompletedThisCycle {
                    return .challenge(challenge)
                }
            }
        }
        return .empty
    }
}
