//
//  ChallengeAttempt.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import Foundation

@Model
class ChallengeAttempt {
    var id = UUID()
    var startedAt: Date
    var completedAt: Date?
    var isOrdered: Bool
    var status: AttemptStatus
    var challenge: Challenge?
    
    init(id: UUID = UUID(), startedAt: Date, completedAt: Date? = nil, isOrdered: Bool = false, status: AttemptStatus, challenge: Challenge? = nil) {
        self.id = id
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.isOrdered = isOrdered
        self.status = status
        self.challenge = challenge
    }
}

