//
//  ChallengeProviderTests.swift
//  OnVantageTests
//
//  Created by Stoyan Hristov on 3.05.26.
//

import SwiftData
import XCTest

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

    func testEmptyQueueReturnsEmpty() {
        let progress = makeProgress()
        let pickerResult = ChallengeProvider.nextChallenge(
            for: progress,
            todayDate: .now
        )

        XCTAssertEqual(pickerResult, .empty, "Expected empty queue")
    }

    func testAlreadyCompletedTodayReturnsDoneForToday() {
        let progress = makeProgress()
        let challenge = makeChallenge(for: progress.category)
        let today = Date.now

        let attempt = ChallengeAttempt(
            startedAt: today,
            status: .completed,
            challenge: challenge
        )
        challenge.attempts.append(attempt)
        context.insert(attempt)

        CycleManager.buildQueue(for: progress)
        let pickerResult = ChallengeProvider.nextChallenge(
            for: progress,
            todayDate: today
        )

        XCTAssertEqual(pickerResult, .doneForToday, "Expected done for today")
    }

    func testNormalPickReturnsFirstUncompletedChallenge() {
        let progress = makeProgress(isOrdered: true)
        let twoDaysAgo = Calendar.current.date(
            byAdding: .day,
            value: -2,
            to: .now
        )!
        progress.cycleStartedAt = twoDaysAgo
        let challenge = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)
        let challenge3 = makeChallenge(for: progress.category)
        let yesterday = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: .now
        )!

        let attempt = ChallengeAttempt(
            startedAt: yesterday,
            status: .completed,
            challenge: challenge
        )
        challenge.attempts.append(attempt)
        context.insert(attempt)

        CycleManager.buildQueue(for: progress)
        let pickerResult = ChallengeProvider.nextChallenge(
            for: progress,
            todayDate: .now
        )

        if case .challenge(let returnedChallenge) = pickerResult {
            XCTAssertEqual(
                returnedChallenge.id,
                challenge2.id,
                "Expected challenge2 id: \(challenge2.id) but got: \(returnedChallenge.id)"
            )
        } else {
            XCTFail("Expected .challenge but got \(pickerResult)")
        }
    }

    func testRemovedChallengeIsNotReturned() {
        let progress = makeProgress(isOrdered: true)
        let twoDaysAgo = Calendar.current.date(
            byAdding: .day,
            value: -2,
            to: .now
        )!
        progress.cycleStartedAt = twoDaysAgo
        let challenge = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)
        let challenge3 = makeChallenge(for: progress.category)
        let yesterday = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: .now
        )!

        let attempt = ChallengeAttempt(
            startedAt: yesterday,
            status: .completed,
            challenge: challenge
        )
        challenge.attempts.append(attempt)
        context.insert(attempt)

        CycleManager.buildQueue(for: progress)
        CycleManager.handleChallengeRemoved(
            challenge2,
            forCategoryProgress: progress
        )
        let pickerResult = ChallengeProvider.nextChallenge(
            for: progress,
            todayDate: .now
        )

        if case .challenge(let returnedChallenge) = pickerResult {
            XCTAssertEqual(
                returnedChallenge.id,
                challenge3.id,
                "Expected \(challenge3.id) but got \(returnedChallenge.id)"
            )
        } else {
            XCTFail("Expected .challenge but got \(pickerResult)")
        }
    }

    func testAddedChallengeEventuallyAppears() {
        let calendar = Calendar.current
        let today = Date.now
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let progress = makeProgress(isOrdered: true)
        progress.cycleStartedAt = threeDaysAgo
        let challenge = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        let attempt = ChallengeAttempt(startedAt: twoDaysAgo, status: .completed, challenge: challenge)
        challenge.attempts.append(attempt)
        context.insert(attempt)
        
        let attempt2 = ChallengeAttempt(startedAt: yesterday, status: .completed, challenge: challenge2)
        challenge2.attempts.append(attempt2)
        context.insert(attempt2)

        let challenge3 = makeChallenge(for: progress.category)
        
        CycleManager.handleChallengeAdded(
            challenge3,
            toCategoryProgress: progress
        )
        
        let pickerResult =  ChallengeProvider.nextChallenge(for: progress, todayDate: .now)

        if case .challenge(let returned) = pickerResult {
            XCTAssertEqual(returned.id, challenge3.id)
        } else {
            XCTFail("Expected .challenge but got \(pickerResult)")
        }

    }
    
    func testAfterNewCyclePickerReturnsFirstAgain() {
        let calendar = Calendar.current
        let today = Date.now
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let progress = makeProgress(isOrdered: true)
        progress.cycleStartedAt = threeDaysAgo
        let challenge = makeChallenge(for: progress.category)
        let challenge2 = makeChallenge(for: progress.category)

        CycleManager.buildQueue(for: progress)
        let attempt = ChallengeAttempt(startedAt: twoDaysAgo, status: .completed, challenge: challenge)
        challenge.attempts.append(attempt)
        context.insert(attempt)
        
        let attempt2 = ChallengeAttempt(startedAt: yesterday, status: .completed, challenge: challenge2)
        challenge2.attempts.append(attempt2)
        context.insert(attempt2)
        
        CycleManager.startNewCycle(for: progress)
        
        let pickerResult = ChallengeProvider.nextChallenge(for: progress)
        
        if case .challenge(let selectedChallenge) = pickerResult {
            XCTAssertEqual(selectedChallenge.id, challenge.id)
        } else {
            XCTFail("Expected .challenge but got \(pickerResult)")
        }
    }

}
