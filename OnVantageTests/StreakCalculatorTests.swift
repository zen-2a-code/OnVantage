//
//  StreakCalculatorTests.swift
//  StreakCalculatorTests
//
//  Created by Stoyan Hristov on 2.05.26.
//

import Foundation
import SwiftData
import XCTest
@testable import OnVantage

@MainActor
final class StreakCalculatorTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(
            for: ChallengeCategory.self,
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
    
    func testFirstCompletionStartsStreakAtOne() {
        // Arrange
        let progress = makeProgress()
        
        // Act
        StreakCalculator.recordCompletion(for: progress)
        // Assert
        XCTAssertEqual(progress.currentStreak, 1, "The current streak should be 1")
    }
    
    func testSameDayCompletionDoesNotIncreaseStreak() {
        let progress = makeProgress(isOrdered: true)
        
        let today = Date.now
        StreakCalculator.recordCompletion(for: progress, todayDate: today)
        StreakCalculator.recordCompletion(for: progress, todayDate: today)
        
        XCTAssertEqual(progress.currentStreak, 1, "The current streak should be 1")
    }
    
    func testConsecutiveDayCompletionAdvancesStreak() {
        let calendar = Calendar.current
        let today = Date.now
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let progress = makeProgress()
        StreakCalculator.recordCompletion(for: progress, todayDate: yesterday)
        StreakCalculator.recordCompletion(for: progress, todayDate: today)
        
        XCTAssertEqual(progress.currentStreak, 2, "The current streak should be 2")
    }
    
    func testMissedDayResetsTheStreak() {
        let calendar = Calendar.current
        let today = Date.now
        let twoDaysBeforeToday = calendar.date(byAdding: .day, value: -2, to: today)!
        
        let progress = makeProgress()
        StreakCalculator.recordCompletion(for: progress, todayDate: twoDaysBeforeToday)
        StreakCalculator.recordCompletion(for: progress, todayDate: today)
        
        XCTAssertEqual(progress.currentStreak, 1, "The current streak should be 1")
    }
    
    
    func testSkipShouldPreserveStreak() {
        // Arrange
        let calendar = Calendar.current
        let today = Date.now
        let oneDaysBeforeToday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysBeforeToday = calendar.date(byAdding: .day, value: -2, to: today)!
        let progress = makeProgress()
        
        // Act
        StreakCalculator.recordCompletion(for: progress, todayDate: twoDaysBeforeToday)
        StreakCalculator.recordSkip(for: progress, todayDate: oneDaysBeforeToday)
        StreakCalculator.recordCompletion(for: progress, todayDate: today)
        
        // Assert
        XCTAssertEqual(progress.currentStreak, 2, "The current streak should be 2")
    }
    
    func testCategoryProgressIsIsolated() {
        // Arrange
        let calendar = Calendar.current
        let today = Date.now
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let progress1 = makeProgress()
        let progress2 = makeProgress()
        
        // Act
        StreakCalculator.recordCompletion(for: progress1, todayDate: yesterday)
        StreakCalculator.recordCompletion(for: progress1, todayDate: today)
        
        // Assert
        XCTAssertEqual(progress1.currentStreak, 2, "The current streak should be 2")
        XCTAssertEqual(progress2.currentStreak, 0, "This category haven't progress at all, should be 0")
    }
    
    func testWhenStreakIsMissedStreakIsBroken() {
        let calendar = Calendar.current
        let today = Date.now
        let twoDaysBeforeToday = calendar.date(byAdding: .day, value: -2, to: today)!
        let threeDaysBeforeToday = calendar.date(byAdding: .day, value: -3, to: today)!
        
        let progress = makeProgress()
        
        StreakCalculator.recordCompletion(for: progress, todayDate: threeDaysBeforeToday)
        StreakCalculator.recordCompletion(for: progress, todayDate: twoDaysBeforeToday)
        // nothing for yesterday
        // nothing for today

        StreakCalculator.evaluateStreakStatus(for: progress, todayDate: today)
        
        XCTAssertEqual(progress.currentStreak, 0, "The current streak should be 0. Because the streak was broken")
    }
    
    func makeProgress(isOrdered: Bool = false) -> CategoryProgress {
        let category = ChallengeCategory(
            name: "Test",
            gradientName: "aurora",
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
