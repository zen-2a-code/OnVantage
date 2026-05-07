//
//  CategoriesView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import SwiftData
import SwiftUI

struct CategoriesView: View {
    @Query private var categories: [Category]
    @State private var viewModel: ViewModel

    init(modelContext: ModelContext) {
        self._viewModel = State(
            initialValue: ViewModel(modelContext: modelContext)
        )
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(categories) { category in
                    @Bindable var category = category
                    NavigationLink(value: category) {
                        CategoryCardView(
                            category: category,
                            onRequestDelete: {
                                viewModel.requestDelete(category)
                            },
                            onSetActive: { isActive in
                                viewModel.setActiveStatus(
                                    isActive,
                                    for: category
                                )
                            }
                        )
                        .padding()
                    }
                    .foregroundStyle(.primary)
                }
            }
            .alert(
                "Delete \(viewModel.categoryToDelete?.name ?? "")",
                isPresented: $viewModel.showDeleteAlert
            ) {
                Button("Delete", role: .destructive) {
                    viewModel.confirmDelete()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this category?")
            }
            .navigationDestination(for: Category.self) { category in
                CategoryDetailView(category: category)
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let category = PreviewHelper.makeCategory(name: "Fitness")
    let progress = PreviewHelper.makeProgress(for: category)
    let _ = PreviewHelper.makeChallenge(for: category)
    let _ = { CycleManager.buildQueue(for: progress) }()
    let _ = {
        category.challenges.first!.attempts.append(
            ChallengeAttempt(startedAt: .now, status: .completed)
        )
    }()

    CategoriesView(modelContext: PreviewHelper.container.mainContext)
        .modelContainer(PreviewHelper.container)
}
