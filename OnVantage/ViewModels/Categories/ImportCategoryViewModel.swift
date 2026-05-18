//
//  ImportCategoryViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.


import SwiftData
import SwiftUI

extension ImportCategoryView {
    @Observable
    class ViewModel {
        enum ImportState {
            case idle
            case parsed(ImportedCategoryDTO)
            case success(Int)
            case error(String)
        }

        var modelContext: ModelContext
        var state: ImportState = .idle
        var showFilePicker: Bool = false
        var categoryName: String = ""
        var selectedGradient: CategoryGradient = .ocean
        var selectedIconName: String = "star.fill"

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func handleFileSelection(_ url: URL) {
            do {
                let dto = try JSONCategoryImporter.parse(url: url)
                categoryName = dto.categoryName
                state = .parsed(dto)
            } catch let error as CategoryImportError {
                state = .error(error.errorDescription ?? "Unknown error")
            } catch {
                state = .error("Something unexpected went wrong.")
            }
        }

        func confirmImport(dto: ImportedCategoryDTO) {
            let category = ChallengeCategory(
                name: categoryName,
                gradientName: selectedGradient.rawValue,
                iconName: selectedIconName,
                isActive: true,
                isUserCreated: false,
                createdAt: .now
            )
            let progress = CategoryProgress(
                category: category,
                cycleStartedAt: .now,
                isOrdered: dto.isOrdered
            )
            category.progress = progress
            modelContext.insert(category)
            modelContext.insert(progress)

            for challengeDTO in dto.challenges {
                let challenge = Challenge(
                    title: challengeDTO.title,
                    conceptExplanation: challengeDTO.conceptExplanation,
                    taskDescription: challengeDTO.taskDescription,
                    difficulty: challengeDTO.difficulty,
                    isUserCreated: false,
                    createdAt: .now,
                    category: category
                )
                category.challenges.append(challenge)
                modelContext.insert(challenge)
            }

            CycleManager.buildQueue(for: progress)
            try? modelContext.save()
            state = .success(dto.challenges.count)
        }

        func reset() {
            state = .idle
            categoryName = ""
            selectedGradient = .ocean
            selectedIconName = "star.fill"
        }
    }
}
