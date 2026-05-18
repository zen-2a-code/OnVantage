//
//  CategoryDetailsViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 10.05.26.
//

import SwiftData
import SwiftUI

extension CategoryDetailsView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var challengeToModify: Challenge?
        var showDeleteAlert: Bool = false
        var showAddModifyChallengeSheet: Bool = false
        var showNotificationSheet: Bool = false

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func requestDelete(_ challenge: Challenge) {
            showDeleteAlert = true
            challengeToModify = challenge
        }

        func requestAdd() {
            challengeToModify = nil
            showAddModifyChallengeSheet = true
        }

        func confirmDelete() {
            guard let challengeToModify = challengeToModify else { return }

            if let progress = challengeToModify.category.progress {
                CycleManager.handleChallengeRemoved(
                    challengeToModify,
                    forCategoryProgress: progress
                )
            }

            modelContext.delete(challengeToModify)
            try? self.modelContext.save()

            self.challengeToModify = nil
            self.showDeleteAlert = false
        }

        func requestEdit(_ challenge: Challenge) {
            challengeToModify = challenge
            showAddModifyChallengeSheet = true
        }

        func sortedChallenges(for category: ChallengeCategory) -> [Challenge] {
            guard let queueOrder = category.progress?.challengeQueueOrder,
                !queueOrder.isEmpty
            else {
                return category.challenges
            }

            return category.challenges.sorted { a, b in
                let indexA = queueOrder.firstIndex(of: a.id) ?? Int.max
                let indexB = queueOrder.firstIndex(of: b.id) ?? Int.max
                return indexA < indexB
            }
        }
    }
}
