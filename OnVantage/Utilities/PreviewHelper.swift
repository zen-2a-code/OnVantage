//
//  PreviewHelper.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import Foundation
import SwiftData

#if DEBUG
    enum PreviewHelper {
        static var container: ModelContainer = {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try! ModelContainer(
                for: ChallengeCategory.self,
                CategoryProgress.self,
                Challenge.self,
                ChallengeAttempt.self,
                configurations: config
            )
        }()

        static func makeCategory(name: String = "Fitness") -> ChallengeCategory
        {
            let category = ChallengeCategory(
                name: name,
                gradientName: CategoryGradient.peach.rawValue,
                iconName: "dumbbell",
                isActive: true,
                isUserCreated: false,
                createdAt: .now
            )
            container.mainContext.insert(category)
            return category
        }

        static func makeChallenge(for category: OnVantage.ChallengeCategory)
            -> Challenge
        {
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
            container.mainContext.insert(challenge)
            return challenge
        }

        static func makeProgress(
            for category: OnVantage.ChallengeCategory,
            isOrdered: Bool = false
        ) -> CategoryProgress {
            let progress = CategoryProgress(
                category: category,
                cycleStartedAt: .now,
                isOrdered: isOrdered
            )
            category.progress = progress
            container.mainContext.insert(progress)
            return progress
        }

    }
#endif
