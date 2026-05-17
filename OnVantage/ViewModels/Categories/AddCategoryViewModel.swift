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
        var gradientName: String = "sunset"
        var iconName: String = "star.fill"
        var isShuffleEnabled = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func isAddNewCategoryDisabled() -> Bool {
            !(name.count >= 3 && !gradientName.isEmpty && !iconName.isEmpty)
        }
        
        func addNewCategory() {
            let newCategory = ChallengeCategory(name: name, gradientName: gradientName, iconName: iconName, isActive: true, isUserCreated: true, createdAt: .now)
            let progress = CategoryProgress(category: newCategory , cycleStartedAt: .now, isOrdered: !isShuffleEnabled)
            newCategory.progress = progress
            modelContext.insert(newCategory)
            modelContext.insert(progress)
        }
    }
}
