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

            // MARK: Stats Panel
            if let progress = category.progress {
                VStack(spacing: 12) {

                    HStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                            Text("\(progress.currentStreak)")
                            Text("streak")
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.yellow)
                            Text("\(progress.longestStreak)")
                            Text("best")
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: progress.orderModeIcon)
                                .foregroundStyle(.secondary)
                            Text(progress.orderModeLabel)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)

                    if progress.totalChallenges > 0 {
                        VStack(spacing: 4) {
                            ProgressView(
                                value: Double(progress.totalChallengesCompleted),
                                total: Double(progress.totalChallenges)
                            )
                            HStack {
                                Text(
                                    "\(progress.totalChallengesCompleted)/\(progress.totalChallenges) this cycle"
                                )
                                Spacer()
                                Text("Cycle \(progress.cycleNumber)")
                            }
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding()
            }

            // MARK: Challenge List
            if category.challenges.isEmpty {
                ContentUnavailableView(
                    "No Challenges",
                    systemImage: "flag.slash",
                    description: Text("Tap + to add your first challenge.")
                )
                .padding(.top, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.sortedChallenges(for: category)) { challenge in
                        ChallengeCardView(
                            challenge: challenge,
                            onEdit: { viewModel.requestEdit(challenge) },
                            onDelete: { viewModel.requestDelete(challenge) }
                        )
                    }
                }
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            (CategoryGradient(rawValue: category.gradientName) ?? .fallback)
                .gradient
                .ignoresSafeArea()
        )
        .navigationTitle($category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.showNotificationSheet = true
                } label: {
                    Image(systemName: "bell")
                }
            }

            ToolbarItem {
                Button {
                    viewModel.requestAdd()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showNotificationSheet) {
            NotificationSettingsView(category: category)
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
        UserDefaults.standard.removeObject(forKey: "didSeed_seed_swiftui")
        SeedImporter.loadSeedData(
            context: container.mainContext,
            resource: "seed_swiftui"
        )

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

    #Preview("Manual") {
        let container = PreviewHelper.container
        let category = PreviewHelper.makeCategory()
        let _ = { category.gradientName = CategoryGradient.rose.rawValue }()
        let progress = PreviewHelper.makeProgress(for: category)
        let _ = { progress.isOrdered = true }()
        let _ = PreviewHelper.makeChallenge(for: category)
        let _ = PreviewHelper.makeChallenge(for: category)
        return NavigationStack {
            CategoryDetailsView(
                category: category,
                modelContext: container.mainContext
            )
            .modelContainer(container)
        }
    }
#endif
