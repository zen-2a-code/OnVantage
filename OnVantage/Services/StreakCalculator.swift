//
//  StreakCalculator.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 30.04.26.
//

import Foundation

enum StreakCalculator {
    /// Records a challenge completion and updates the streak state for the given category.
    ///
    /// Call this method only when the user taps "Mark Complete".
    /// The streak logic is based on `lastCompletedDate` and `lastActivityDate`:
    /// - Same day completion - ignored, no changes ( no streak increase - only 1 complated challenge per category advances the streak )
    /// - First ever completion -  streak starts at 1
    /// - If there was a Completed challenge yesterday - streak advances
    /// - No completion yesterday but a skip was used - streak survives to today, advances due to today's completion
    /// - No activity yesterday nor `lastCompletedDate` or `lastActivityDate`: - streak resets to 1
    ///
    /// - Parameters:
    ///   - progress: The ``CategoryProgress`` object to mutate. Must belong to the category being completed.
    ///   - todayDate: The date of the completion. Defaults to `Date.now`. Inject a custom date in unit tests.
    static func recordCompletion(
        for progress: CategoryProgress,
        todayDate: Date = .now
    ) {
        let calendar = Calendar.current

        if let lastCompletedDate = progress.lastCompletedDate,
            calendar.isDate(lastCompletedDate, inSameDayAs: todayDate)
        {
            return
        }

        guard let lastCompletedDate = progress.lastCompletedDate else {
            updateStreak(progress: progress, with: todayDate)
            return
        }

        if let yesterday = calendar.date(
            byAdding: .day,
            value: -1,
            to: todayDate
        ) {
            if calendar.isDate(lastCompletedDate, inSameDayAs: yesterday) {
                updateStreak(progress: progress, with: todayDate)

            } else if let lastActivityDate = progress.lastActivityDate,
                calendar.isDate(lastActivityDate, inSameDayAs: yesterday)
            {
                updateStreak(progress: progress, with: todayDate)
            } else {
                updateStreak(
                    progress: progress,
                    with: todayDate,
                    isMissed: true
                )
            }
        }
    }

    private static func updateStreak(
        progress: CategoryProgress,
        with date: Date,
        isMissed: Bool = false
    ) {
        if isMissed {
            progress.currentStreak = 1
        } else {
            progress.currentStreak += 1
        }
        progress.totalCompleted += 1
        progress.lastCompletedDate = date
        progress.lastActivityDate = date

        if progress.currentStreak > progress.longestStreak {
            progress.longestStreak = progress.currentStreak
        }
    }
    /// Applies a skip token to the given category, preserving the streak.
    ///
    /// Call this only when the user taps "Skip" and the ViewModel has confirmed skips are available.
    /// Updates `lastActivityDate` so tomorrow's completion knows something happened today.
    /// Silently does nothing if no skips remain — the ViewModel should prevent this from being called.
    ///
    /// - Parameters:
    ///   - progress: The ``CategoryProgress`` to mutate.
    ///   - todayDate: The date of the skip. Defaults to `Date.now`. Inject a custom date in unit tests.
    static func recordSkip(
        for progress: CategoryProgress,
        todayDate: Date = .now
    ) {
        guard progress.skipsRemainingThisCycle > 0 else { return }

        progress.lastActivityDate = todayDate
        progress.skipsRemainingThisCycle -= 1
    }

    /// Checks whether the streak should be broken and resets it if a day was missed.
    ///
    /// Call this from `.onAppear` for every active category on each app launch.
    /// Does nothing if the user already completed today, or if the category has no activity history.
    ///
    /// - Parameters:
    ///   - progress: The ``CategoryProgress`` to evaluate.
    ///   - todayDate: Today's date. Defaults to `Date.now`. Inject a custom date in unit tests.
    static func evaluateStreakStatus(
        for progress: CategoryProgress,
        todayDate: Date = .now
    ) {
        let calendar = Calendar.current
        guard
            let yesterday = calendar.date(
                byAdding: .day,
                value: -1,
                to: todayDate
            )
        else {
            fatalError(
                "You must have entered an imposible date for todaysDate \(todayDate)"
            )
        }

        if let lastCompletedDate = progress.lastCompletedDate,
            let lastActivityDate = progress.lastActivityDate
        {
            if calendar.isDate(lastCompletedDate, inSameDayAs: todayDate) {
                return
            }
            if !calendar.isDate(lastActivityDate, inSameDayAs: yesterday) {
                progress.currentStreak = 0
            }
        }
    }
}
