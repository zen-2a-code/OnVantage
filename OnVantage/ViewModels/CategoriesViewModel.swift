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
        var showNewCategory: Bool = false
        var showDeleteAlert: Bool = false
        var categoryToDelete: Category? = nil
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func setActiveStatus(_ isActive: Bool, for category: Category) {
            category.isActive = isActive
        }
        func delete(_ category: Category) {
            modelContext.delete(category)
        }
        
        func requestDelete(_ category: Category) {
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
