//
//  AddModifyChallengeViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 10.05.26.
//

import SwiftData
import SwiftUI

extension AddModifyChallengeView {
    @Observable
    final class ViewModel {
        var modelContext: ModelContext
        let category: ChallengeCategory
        let challenge: Challenge?

        var title: String
        var conceptExplanation: String
        var taskDescription: String
        var difficulty: Int

        var isEditMode: Bool { challenge != nil }
        var navTitle: String { isEditMode ? "Edit Challenge" : "Add Challenge" }

        var isSaveDisabled: Bool {
            title.trimmingCharacters(in: .whitespaces).count < 3
                || taskDescription.count < 3
        }

        init(
            modelContext: ModelContext,
            category: ChallengeCategory,
            challenge: Challenge? = nil
        ) {
            self.modelContext = modelContext
            self.category = category
            self.challenge = challenge
            self.title = challenge?.title ?? ""
            self.conceptExplanation = challenge?.conceptExplanation ?? ""
            self.taskDescription = challenge?.taskDescription ?? ""
            self.difficulty = challenge?.difficulty ?? 1
        }

        func save() {
            if let existing = challenge {
                existing.title = title
                existing.conceptExplanation = conceptExplanation
                existing.taskDescription = taskDescription
                existing.difficulty = difficulty
            } else {
                let newChallenge = Challenge(
                    title: title,
                    conceptExplanation: conceptExplanation,
                    taskDescription: taskDescription,
                    difficulty: difficulty,
                    isUserCreated: true,
                    createdAt: .now,
                    category: category
                )
                category.challenges.append(newChallenge)
                modelContext.insert(newChallenge)

                if let progress = category.progress {
                    CycleManager.handleChallengeAdded(
                        newChallenge,
                        toCategoryProgress: progress
                    )
                }

                try? modelContext.save()
            }
        }
    }
}
