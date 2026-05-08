//
//  CycleManagerTests.swift
//  OnVantageTests
//
//  Created by Stoyan Hristov on 2.05.26.
//

import Foundation
import SwiftData
import XCTest

@testable import OnVantage

@MainActor
final class CycleManagerTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(
            for: OnVantage.ChallengeCategory.self,
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

    func makeChallenge(for category: OnVantage.ChallengeCategory) -> Challenge {
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
        let category = ChallengeCategory(
            name: "Test",
            gradientName: "fire",
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

    func testBuildQueuePopulatesTheQueue() {
        let progress = makeProgress()
        let category = progress.category
        let challenge1 = makeChallenge(for: category)
        let challenge2 = makeChallenge(for: category)
        let challenge3 = makeChallenge(for: category)

        CycleManager.buildQueue(for: progress)

        XCTAssertEqual(progress.category.challenges.count, 3)
        XCTAssertTrue(progress.challengeQueueOrder.contains(challenge1.id))
        XCTAssertTrue(progress.challengeQueueOrder.contains(challenge2.id))
        XCTAssertTrue(progress.challengeQueueOrder.contains(challenge3.id))
    }

    func testHandleChallengeAddedOrderedAppendsToEnd() {
        let progress = makeProgress(isOrdered: true)
        let _ = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        let lastChallenge = makeChallenge(for: progress.category)
        CycleManager.handleChallengeAdded(
            lastChallenge,
            toCategoryProgress: progress
        )

        XCTAssertEqual(
            progress.challengeQueueOrder.last,
            lastChallenge.id,
            "Challenge should be added to the end of the queue"
        )

    }

    func testHandleChallengeAddedUnorderedAppearsInQueue() {
        let progress = makeProgress(isOrdered: false)
        let _ = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        let lastChallenge = makeChallenge(for: progress.category)
        CycleManager.handleChallengeAdded(
            lastChallenge,
            toCategoryProgress: progress
        )

        XCTAssertTrue(
            progress.challengeQueueOrder.contains(lastChallenge.id),
            "Challenge should be added to any position of the queue"
        )
    }

    func testHandleChallengeRemovedIDIsGoneFromQueue() {
        let progress = makeProgress(isOrdered: false)
        let _ = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)
        let challengeToRemove = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        CycleManager.handleChallengeRemoved(
            challengeToRemove,
            forCategoryProgress: progress
        )

        XCTAssertFalse(
            progress.challengeQueueOrder.contains(challengeToRemove.id),
            "Challenge should be removed from the queue"
        )
    }

    func testCheckCycleCompletionReturnsTrueWhenAllCompleted() {
        let progress = makeProgress()
        let challenge1 = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)
        let challenge3 = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)

        for currentChallenge in [challenge1, challenge2, challenge3] {
            let attempt = ChallengeAttempt(
                startedAt: .now,
                status: .completed,
                challenge: currentChallenge
            )
            currentChallenge.attempts.append(attempt)
            context.insert(attempt)
        }

        XCTAssertTrue(
            CycleManager.checkCycleCompletion(for: progress),
            "Should be true if all challenges have been completed"
        )
    }

    func testCheckCycleCompletionReturnsFalseWhenNotAllCompleted() {
        let progress = makeProgress()
        let challenge1 = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)
        let _ = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        for currentChallenge in [challenge1, challenge2] {
            let attempt = ChallengeAttempt(
                startedAt: .now,
                status: .completed,
                challenge: currentChallenge
            )

            currentChallenge.attempts.append(attempt)
            context.insert(attempt)
        }

        XCTAssertFalse(
            CycleManager.checkCycleCompletion(for: progress),
            "Should be false if NOT all challenges have been completed"
        )
    }

    func testStartNewCycleBumpsNumberAndResetsSkips() {
        let progress = makeProgress()

        progress.skipsRemainingThisCycle = 2
        //        StreakCalculator.recordSkip(for: progress) // not sure if this is better or not; the above is more direct, but if I implement changes to recordSkip (and break SOLID) i will have problems with the test; but the above is more readable.
        CycleManager.startNewCycle(for: progress)

        XCTAssertEqual(progress.cycleNumber, 2, "Should increment cycle number")
        XCTAssertEqual(
            progress.skipsRemainingThisCycle,
            3,
            "Should reset skips == 3"
        )
    }
}
