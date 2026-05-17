//
//  Challenge.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation
import SwiftData

@Model
class Challenge: Equatable {
    var id = UUID()
    var title: String
    var conceptExplanation: String
    var taskDescription: String
    var difficulty: Int
    var isUserCreated: Bool
    var createdAt: Date
    var category: ChallengeCategory
    var attempts: [ChallengeAttempt] = []

    init(
        id: UUID = UUID(),
        title: String,
        conceptExplanation: String,
        taskDescription: String,
        difficulty: Int,
        isUserCreated: Bool,
        createdAt: Date,
        category: ChallengeCategory,
        attempts: [ChallengeAttempt] = []
    ) {
        self.id = id
        self.title = title
        self.conceptExplanation = conceptExplanation
        self.taskDescription = taskDescription
        self.difficulty = difficulty
        self.isUserCreated = isUserCreated
        self.createdAt = createdAt
        self.category = category
        self.attempts = attempts
    }

    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        lhs.id == rhs.id
    }
}
