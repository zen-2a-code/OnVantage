//
//  SeedImporter.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 29.04.26.
//

import Foundation
import SwiftData

enum SeedImporter {
    static func loadSeedData(context: ModelContext, resource: String) {
        let seedKey = "didSeed_\(resource)"
        guard !UserDefaults.standard.bool(forKey: seedKey) else { return }

        let jsonDecoder = JSONDecoder()

        guard
            let seedURL = Bundle.main.url(
                forResource: resource,
                withExtension: "json"
            )
        else {
            fatalError("Missing seed JSON file")
        }

        guard let seedData = try? Data(contentsOf: seedURL) else {
            fatalError("Could not read seed file")
        }

        guard
            let seedFileDTO = try? jsonDecoder.decode(
                SeedFileDTO.self,
                from: seedData
            )
        else {
            fatalError("Could not decode seed JSON")
        }

        let swiftCategory = ChallengeCategory(
            name: seedFileDTO.category.name,
            gradientName: seedFileDTO.category.gradientName,
            iconName: seedFileDTO.category.iconName,
            isActive: true,
            isUserCreated: false,
            createdAt: .now
        )

        var challengesList = [Challenge]()
        var challengesUUIDS = [UUID]()
        for seedCategoryChallenge in seedFileDTO.challenges {
            let challenge = Challenge(
                title: seedCategoryChallenge.title,
                conceptExplanation: seedCategoryChallenge
                    .conceptExplanation,
                taskDescription: seedCategoryChallenge.taskDescription,
                difficulty: seedCategoryChallenge.difficulty,
                isUserCreated: false,
                createdAt: .now,
                category: swiftCategory
            )

            challengesUUIDS.append(challenge.id)
            challengesList.append(challenge)
        }

        swiftCategory.challenges = challengesList

        let categoryProgress = CategoryProgress(
            category: swiftCategory,
            cycleStartedAt: .now,
            isOrdered: seedFileDTO.isOrdered
        )
        categoryProgress.challengeQueueOrder = seedFileDTO.isOrdered
            ? challengesUUIDS
            : challengesUUIDS.shuffled()
        swiftCategory.progress = categoryProgress

        context.insert(swiftCategory)
        UserDefaults.standard.set(true, forKey: seedKey)
    }
}

struct SeedFileDTO: Codable {
    var category: SeedCategoryDTO
    var isOrdered: Bool
    var challenges: [SeedChallangeDTO]
}

struct SeedCategoryDTO: Codable {
    var name: String
    var gradientName: String
    var iconName: String
}

struct SeedChallangeDTO: Codable {
    var title: String
    var conceptExplanation: String
    var taskDescription: String
    var difficulty: Int
}
