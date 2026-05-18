//
//  HomeView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

internal import Combine
import SwiftData
import SwiftUI

struct HomeView: View {
    @Query var categories: [ChallengeCategory]
    @State var viewModel: ViewModel

    init(modelContext: ModelContext) {
        self._viewModel = State(
            initialValue: ViewModel(modelContext: modelContext)
        )
    }

    private var activeCategories: [ChallengeCategory] {
        viewModel.sortedActiveCategories(from: categories)
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                if activeCategories.isEmpty {
                    ContentUnavailableView(
                        "No Active Challenges",
                        systemImage: "checklist",
                        description: Text(
                            "Add a category in the Categories tab to get started."
                        )
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(activeCategories) { category in
                        let challenge = viewModel.nextChallenge(for: category)
                        HomeCategoryCardView(
                            category: category,
                            challenge: challenge,
                            hasChallenge: viewModel.hasChallengeToday(for: category),
                            statusText: viewModel.statusText(for: category),
                            hourGlassRotationAngle: viewModel.hourGlassRotationAngle,
                            onSkip: {
                                if let challenge {
                                    viewModel.skip(for: category, challenge: challenge)
                                }
                            }
                        )
                    }
                }
            }
            .navigationTitle("Daily Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Challenge.self) { challenge in
                ChallengeDetailsView(
                    challenge: challenge,
                    modelContext: viewModel.modelContext,
                    onNavigateBackToHomeScreen: { viewModel.clearNavigation() }
                )
            }
            .onAppear {
                viewModel.tickCountdown()
                activeCategories.forEach { category in
                    if let progress = category.progress {
                        StreakCalculator.evaluateStreakStatus(for: progress)
                    }
                }
            }
            .animation(.smooth, value: viewModel.hourGlassRotationAngle)
            .animation(.smooth, value: viewModel.timeUntilTomorrow)
            .onReceive(viewModel.hourglassRotationTimer) { _ in
                viewModel.tickHourglass()
            }
            .onReceive(viewModel.countDownTimer) { _ in
                viewModel.tickCountdown()
            }
        }
    }

}

#if DEBUG
    private struct PreviewHelperView<Content: View>: View {
        @Query var categories: [ChallengeCategory]
        let content: ([ChallengeCategory]) -> Content

        var body: some View {
            content(categories)
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeed_seed_swiftui")
        SeedImporter.loadSeedData(
            context: container.mainContext,
            resource: "seed_swiftui"
        )

        return PreviewHelperView { _ in
            HomeView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
#endif
