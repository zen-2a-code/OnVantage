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

    var activeCategories: [ChallengeCategory] {
        categories.filter { $0.isActive }
    }
    @State var viewModel: ViewModel

    init(modelContext: ModelContext) {
        self._viewModel = State(
            initialValue: ViewModel(
                modelContext: modelContext
            )
        )
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                ForEach(activeCategories) { category in
                    VStack {
                        Text(category.name)
                            .font(.largeTitle)

                        HStack {
                            Text(
                                "Current Streak: \(category.progress?.currentStreak ?? 0)"
                            )
                            Text(" | ")
                            Text(
                                "Longest Streak: \(category.progress?.longestStreak ?? 0)"
                            )
                        }
                        .foregroundStyle(.secondary)

                        VStack(spacing: 13) {
                            if viewModel.hasChallengeToday(for: category) {
                                if let challenge = viewModel.nextChallenge(
                                    for: category
                                ) {
                                    NavigationLink(
                                        value: challenge
                                    ) {
                                        VStack(spacing: 13) {
                                            Text("Time remaining:")
                                                .foregroundStyle(.secondary)
                                            Text(
                                                viewModel.statusText(
                                                    for: category
                                                )
                                            )
                                            Image(
                                                systemName:
                                                    "hourglass.bottomhalf.filled"
                                            )
                                            .foregroundStyle(.secondary)
                                            .font(.largeTitle)
                                            .rotationEffect(
                                                .degrees(
                                                    viewModel
                                                        .hourGlassRotationAngle
                                                )
                                            )
                                            HStack(spacing: 10) {
                                                Button(
                                                    "Skip (\(category.progress?.skipsRemainingThisCycle ?? 0) left)",
                                                    role: .destructive
                                                ) {
                                                    viewModel.skip(
                                                        for: category, challenge: challenge
                                                    )
                                                }
                                                .disabled(
                                                    (category.progress?
                                                        .skipsRemainingThisCycle
                                                        ?? 0) == 0
                                                )
                                                .padding()
                                                .background(
                                                    .white.opacity(0.4)
                                                )
                                                .clipShape(
                                                    .rect(cornerRadius: 20)
                                                )

                                                Text("Ready?")
                                                    .padding()
                                                    .background(
                                                        .white.opacity(0.4)
                                                    )
                                                    .clipShape(
                                                        .rect(cornerRadius: 20)
                                                    )
                                            }

                                        }
                                    }
                                }
                            } else {
                                VStack(spacing: 13) {
                                    Text(
                                        viewModel.statusText(for: category)
                                    )
                                    .font(.headline)
                                    Image(systemName: "hands.and.sparkles")
                                        .foregroundStyle(.secondary)
                                        .font(.largeTitle)
                                    Text("Good job!")
                                    Text("Or add some more?")
                                        .foregroundStyle(.secondary)
                                        .font(.caption2)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300, height: 200)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        CategoryGradient(rawValue: category.gradientName)?
                            .gradient
                    )
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Daily Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                for: Challenge.self,
                destination: { challenge in
                    ChallengeDetailsView(
                        challenge: challenge,
                        modelContext: viewModel.modelContext,
                        onNavigateBackToHomeScreen: {
                            viewModel.clearNavigation()
                        }
                    )
                }
            )
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
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

        return
            PreviewHelperView { categories in
                HomeView(
                    modelContext: container.mainContext
                )
            }
            .modelContainer(container)

    }
#endif
