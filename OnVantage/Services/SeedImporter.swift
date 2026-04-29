//
//  SeedImporter.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 29.04.26.
//

import Foundation
import SwiftData

enum SeedImporter {
    static func loadSeedData(context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: "didSeedV1") else { return }

        let jsonDecoder = JSONDecoder()
        
        if let seedURL = Bundle.main.url(
            forResource: "seed_swiftui",
            withExtension: "json"
        ) {
            if let seedData = try? Data(contentsOf: seedURL) {
                if let seedCategoryDTO = try? jsonDecoder.decode(
                    SeedCategoryDTO.self,
                    from: seedData
                ) {
                    let swiftCategory = Category(
                        name: seedCategoryDTO.name,
                        colorHex: seedCategoryDTO.colorHex,
                        iconName: seedCategoryDTO.iconName,
                        isActive: true,
                        isUserCreated: false,
                        createdAt: .now
                    )

                    var challengesList = [Challenge]()
                    var challengesUUIDS = Array<UUID>()
                    for seedCategoryChallenge in seedCategoryDTO.challenges {
                        let challenge = Challenge(
                            title: seedCategoryChallenge.title,
                            conceptExplanation: seedCategoryChallenge.conceptExplanation,
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
                    
                    let categoryProgress = CategoryProgress(category: swiftCategory, cycleStartedAt: .now)
                    categoryProgress.shuffledOrder = challengesUUIDS.shuffled()
                    swiftCategory.progress = categoryProgress
                    
                    context.insert(swiftCategory)
                    UserDefaults.standard.set(true, forKey: "didSeedV1")
                    return
                }
            }
        }

        fatalError("Unable to load seed data from JSON")
    }
}

struct SeedCategoryDTO: Codable {
    var name: String
    var colorHex: String
    var iconName: String
    var challenges: [SeedChallangesDTO]
}

struct SeedChallangesDTO: Codable {
    var title: String
    var conceptExplanation: String
    var taskDescription: String
    var difficulty: Int
}
