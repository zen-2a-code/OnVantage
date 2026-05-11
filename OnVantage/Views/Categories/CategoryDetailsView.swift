//
//  CategoryDetailView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import SwiftData
import SwiftUI

struct CategoryDetailsView: View {
    @Bindable var category: ChallengeCategory
    @State var viewModel: ViewModel

    init(category: ChallengeCategory, modelContext: ModelContext) {
        self.category = category
        self._viewModel = State(
            initialValue: ViewModel(modelContext: modelContext)
        )
    }
    var body: some View {
        ScrollView {
            VStack {
                if let progress = category.progress {
                    HStack {
                        Image(systemName: progress.orderModeIcon)
                        Text("Challenges order - \(progress.orderModeLabel)")
                    }

                    Text("Cycles completed: \(progress.cyclesCompleted)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(
                    "Category created on: \(category.createdAt, format: .dateTime)"
                )
                .font(.caption2)
                .foregroundStyle(.secondary)

            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.7))
            }
            .padding()

            if !category.challenges.isEmpty {
                ForEach(category.challenges) { challenge in
                    ChallengeCardView(
                        challenge: challenge,
                        onEdit: { viewModel.requestEdit(challenge) },
                        onDelete: { viewModel.requestDelete(challenge) }
                    )
                }

            } else {
                ContentUnavailableView(
                    "No challenges",
                    systemImage: "flag.slash"
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            (CategoryGradient(rawValue: category.gradientName) ?? .fallback)
                .gradient
        )
        .navigationTitle($category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.requestAdd()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddModifyChallengeSheet) {
            AddModifyChallengeView(
                modelContext: viewModel.modelContext,
                category: category,
                challenge: viewModel.challengeToModify
            )
        }
        .alert(
            "Delete \(viewModel.challengeToModify?.title ?? "")?",
            isPresented: $viewModel.showDeleteAlert
        ) {
            Button("Delete", role: .destructive) { viewModel.confirmDelete() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#if DEBUG
    private struct PreviewHelperView<Content: View>: View {
        @Query var categories: [ChallengeCategory]
        let content: (ChallengeCategory) -> Content

        var body: some View {
            if let category = categories.first {
                content(category)
            }
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

        return NavigationStack {
            PreviewHelperView { category in
                CategoryDetailsView(
                    category: category,
                    modelContext: container.mainContext
                )
            }
            .modelContainer(container)
        }
    }
#endif

#Preview {
    let container = PreviewHelper.container
    let category = PreviewHelper.makeCategory()
    let _ = { category.gradientName = CategoryGradient.rose.rawValue }()
    let progress = PreviewHelper.makeProgress(for: category)
    let _ = { progress.isOrdered = true }()
    let challenge = PreviewHelper.makeChallenge(for: category)
    let challenge2 = PreviewHelper.makeChallenge(for: category)
    NavigationStack {
        CategoryDetailsView(
            category: category,
            modelContext: container.mainContext
        )
        .modelContainer(container)
    }
}
