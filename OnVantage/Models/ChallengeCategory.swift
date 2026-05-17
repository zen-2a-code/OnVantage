//
//  Category.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation
import SwiftData

@Model
class ChallengeCategory {
    var id = UUID()
    var name: String
    var gradientName: String
    var iconName: String
    var isActive: Bool
    var isUserCreated: Bool
    var createdAt: Date
    var challenges: [Challenge] = []
    var progress: CategoryProgress?

    init(
        id: UUID = UUID(),
        name: String,
        gradientName: String,
        iconName: String,
        isActive: Bool,
        isUserCreated: Bool,
        createdAt: Date,
        challenges: [Challenge] = [],
        progress: CategoryProgress? = nil
    ) {
        self.id = id
        self.name = name
        self.gradientName = gradientName
        self.iconName = iconName
        self.isActive = isActive
        self.isUserCreated = isUserCreated
        self.createdAt = createdAt
        self.challenges = challenges
        self.progress = progress
    }
}
