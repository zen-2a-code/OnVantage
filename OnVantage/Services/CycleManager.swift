//
//  CycleManager.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 1.05.26.
//

import Foundation

enum CycleManager {

    /// Builds and assigns the challenge queue order for the given category progress.
    ///
    /// If the category is unordered, the challenge IDs are shuffled randomly.
    /// If the category is ordered, the IDs are assigned in their natural order from `category.challenges`.
    /// Call this when a category is first created.
    ///
    /// - Parameter progress: The ``CategoryProgress`` to mutate.
    static func buildQueue(for progress: CategoryProgress) {
        var challengesUUIDs = progress.category.challenges.map { challenge in
            challenge.id
        }

        if !progress.isOrdered {
            challengesUUIDs.shuffle()
        }

        progress.challengeQueueOrder = challengesUUIDs
    }

    /// Inserts a newly created challenge into the current cycle's queue.
    ///
    /// For unordered categories, the ID is inserted at a random valid position so the new challenge
    /// appears at an unpredictable point in the remaining cycle.
    /// For ordered categories, the ID is appended to the end of the queue.
    /// Call this after the ViewModel has already inserted the ``Challenge`` into the database.
    ///
    /// - Parameters:
    ///   - newChallenge: The newly created ``Challenge`` whose ID will be inserted into the queue.
    ///   - progress: The ``CategoryProgress`` whose `challengeQueueOrder` will be mutated.
    static func handleChallengeAdded(
        _ newChallenge: Challenge,
        toCategoryProgress progress: CategoryProgress
    ) {
        if progress.isOrdered {
            progress.challengeQueueOrder.append(newChallenge.id)
        } else {
            let randomIndex = Int.random(
                in: 0...progress.challengeQueueOrder.count
            )
            progress.challengeQueueOrder.insert(
                newChallenge.id,
                at: randomIndex
            )
        }
    }

    static func handleChallengeRemoved(
        _ challengeToRemove: Challenge,
        forCategoryProgress progress: CategoryProgress
    ) {
        let currentID = challengeToRemove.id
        progress.challengeQueueOrder.removeAll { id in
            id == currentID
        }
    }

    static func checkCycleCompletion(for progress: CategoryProgress) -> Bool {
        guard !progress.challengeQueueOrder.isEmpty else { return false }

        return progress.challengeQueueOrder.allSatisfy { challengeID in
            let currentChallenge = progress.category.challenges.first {
                $0.id == challengeID
            }

            if let attempts = currentChallenge?.attempts {
                return attempts.contains { challengeAttempt in
                    challengeAttempt.startedAt > progress.cycleStartedAt
                        && challengeAttempt.status == .completed
                }
            } else {
                return false
            }
        }
    }

    static func startNewCycle(for progress: CategoryProgress) {
        progress.cycleStartedAt = .now
        progress.cycleNumber += 1
        progress.skipsRemainingThisCycle = 3

        if !progress.isOrdered {
            progress.challengeQueueOrder.shuffle()
        }
    }
}
