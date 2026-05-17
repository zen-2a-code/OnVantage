//
//  CategoriesViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 7.05.26.
//

import SwiftData
import SwiftUI

extension CategoriesView {
    @Observable
    final class ViewModel {
        var modelContext: ModelContext
        var showDeleteAlert: Bool = false
        var showNewCategorySheet: Bool = false
        var categoryToDelete: ChallengeCategory? = nil

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func setActiveStatus(_ isActive: Bool, for category: ChallengeCategory)
        {
            category.isActive = isActive
        }

        func requestDelete(_ category: ChallengeCategory) {
            categoryToDelete = category
            showDeleteAlert = true
        }

        func confirmDelete() {
            guard let category = categoryToDelete else { return }
            modelContext.delete(category)
            categoryToDelete = nil
            showDeleteAlert = false
        }
    }
}
