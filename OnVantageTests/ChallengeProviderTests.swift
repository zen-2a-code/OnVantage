//
//  ChallengeProviderTests.swift
//  OnVantageTests
//
//  Created by Stoyan Hristov on 3.05.26.
//

import XCTest
import SwiftData
@testable import OnVantage

@MainActor
final class ChallengeProviderTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(
            for: OnVantage.Category.self,
            CategoryProgress.self,
            Challenge.self,
            ChallengeAttempt.self,
            configurations: config
        )
        context = ModelContext(container)
    }

    override func tearDown() {
        container = nil
        context = nil
    }
    
    func makeChallenge(for category: OnVantage.Category) -> Challenge {
        let challenge = Challenge(
            title: "Test Challenge",
            conceptExplanation: "Some concept",
            taskDescription: "Some task",
            difficulty: 1,
            isUserCreated: false,
            createdAt: .now,
            category: category
        )
        category.challenges.append(challenge)
        context.insert(challenge)
        return challenge
    }

    func makeProgress(isOrdered: Bool = false) -> CategoryProgress {
        let category = Category(
            name: "Test",
            colorHex: "#000000",
            iconName: "star",
            isActive: true,
            isUserCreated: false,
            createdAt: .now
        )
        let progress = CategoryProgress(
            category: category,
            cycleStartedAt: .now,
            isOrdered: isOrdered
        )
        context.insert(category)
        context.insert(progress)
        return progress
    }
    
    
}
