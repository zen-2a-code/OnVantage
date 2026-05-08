//
//  CategoryProgress.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation
import SwiftData

@Model
class CategoryProgress {
    var id = UUID()
    var category: ChallengeCategory
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastCompletedDate: Date?
    var lastActivityDate: Date?
    var totalCompleted: Int = 0
    var skipsRemainingThisCycle: Int = 3
    var cycleStartedAt: Date
    var cycleNumber: Int = 1
    var challengeQueueOrder: [UUID] = []
    var isOrdered: Bool
    var notificationEnabled: Bool = false
    var notificationHour: Int?
    var notificationMinute: Int?

    var totalChallenges: Int {
        challengeQueueOrder.count
    }

    var totalChallengesCompleted: Int {
        category.challenges.filter { challenge in
            challenge.attempts.contains { challengeAttempt in
                challengeAttempt.status == .completed
                    && challengeAttempt.startedAt > cycleStartedAt
            }
        }
        .count
    }

    init(
        id: UUID = UUID(),
        category: ChallengeCategory,
        lastCompletedDate: Date? = nil,
        cycleStartedAt: Date,
        shuffledOrder: [UUID] = [],
        isOrdered: Bool = false,
        notificationEnabled: Bool = false,
        notificationHour: Int? = nil,
        notificationMinute: Int? = nil
    ) {
        self.id = id
        self.category = category
        self.lastCompletedDate = lastCompletedDate
        self.cycleStartedAt = cycleStartedAt
        self.challengeQueueOrder = shuffledOrder
        self.isOrdered = isOrdered
        self.notificationEnabled = notificationEnabled
        self.notificationHour = notificationHour
        self.notificationMinute = notificationMinute
    }
}
