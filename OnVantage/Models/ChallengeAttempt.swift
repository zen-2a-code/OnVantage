//
//  ChallengeAttempt.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation
import SwiftData

@Model
class ChallengeAttempt {
    var id = UUID()
    var startedAt: Date
    var completedAt: Date?
    var status: AttemptStatus
    var challenge: Challenge?

    init(
        id: UUID = UUID(),
        startedAt: Date,
        completedAt: Date? = nil,
        status: AttemptStatus,
        challenge: Challenge? = nil
    ) {
        self.id = id
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.status = status
        self.challenge = challenge
    }
}
