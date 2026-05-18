//
//  AddCategoryViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 8.05.26.
//

import SwiftData
import SwiftUI

extension AddCategoryView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var name: String = ""
        var selectedGradient: CategoryGradient = .sunset
        var selectedIconName: String = "star.fill"
        var isShuffleEnabled = false

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func isAddNewCategoryDisabled() -> Bool {
            !(name.count >= 3 && !selectedIconName.isEmpty)
        }

        func addNewCategory() {
            let newCategory = ChallengeCategory(
                name: name,
                gradientName: selectedGradient.rawValue,
                iconName: selectedIconName,
                isActive: true,
                isUserCreated: true,
                createdAt: .now
            )
            let progress = CategoryProgress(
                category: newCategory,
                cycleStartedAt: .now,
                isOrdered: !isShuffleEnabled
            )
            newCategory.progress = progress
            modelContext.insert(newCategory)
            modelContext.insert(progress)
        }
    }
}
