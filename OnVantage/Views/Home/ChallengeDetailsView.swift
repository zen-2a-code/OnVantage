//
//  ChallengeDetailsView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 13.05.26.
//

import SwiftData
import SwiftUI

struct ChallengeDetailsView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        challenge: Challenge,
        modelContext: ModelContext,
        onNavigateBackToHomeScreen: @escaping () -> Void
    ) {
        self._viewModel = State(
            initialValue: ViewModel(
                challenge: challenge,
                modelContext: modelContext,
                onNavigateBackToHomeScreen: onNavigateBackToHomeScreen
            )
        )
    }

    var body: some View {
        ZStack {
            CategoryGradient(rawValue: viewModel.challenge.category.gradientName)?
                .gradient
                .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {

                        HStack(spacing: 6) {
                            ForEach(1...3, id: \.self) { level in
                                Circle()
                                    .fill(
                                        level <= viewModel.challenge.difficulty
                                            ? Color.primary
                                            : Color.primary.opacity(0.2)
                                    )
                                    .frame(width: 10, height: 10)
                            }
                            Text(difficultyLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Concept", systemImage: "lightbulb.max")
                                .font(.headline)
                            Text(viewModel.challenge.conceptExplanation)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Your Task", systemImage: "scope")
                                .font(.headline)
                            Text(viewModel.challenge.taskDescription)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        Button {
                            viewModel.markComplete()
                            if !viewModel.showCycleCompleteSheet {
                                dismiss()
                            }
                        } label: {
                            Label("Mark Complete", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(24)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                }
            }
        }
        .navigationTitle(viewModel.challenge.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showCycleCompleteSheet) {
            CategoryFinishedView(
                categoryName: viewModel.challenge.category.name,
                onRestart: viewModel.restartCycle,
                onArchive: viewModel.archiveCategory,
                onDelete: viewModel.deleteCategory
            )
        }
    }

    private var difficultyLabel: String {
        switch viewModel.challenge.difficulty {
        case 1: return "Easy"
        case 2: return "Medium"
        case 3: return "Hard"
        default: return ""
        }
    }
}

#if DEBUG
    private struct PreviewHelperView<Content: View>: View {
        @Query var challenges: [Challenge]
        let content: (Challenge, ModelContext) -> Content

        var body: some View {
            if let challenge = challenges.first {
                content(challenge, PreviewHelper.container.mainContext)
            }
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeed_seed_swiftui")
        SeedImporter.loadSeedData(context: container.mainContext, resource: "seed_swiftui")

        return NavigationStack {
            PreviewHelperView { challenge, modelContext in
                ChallengeDetailsView(
                    challenge: challenge,
                    modelContext: modelContext,
                    onNavigateBackToHomeScreen: {}
                )
            }
            .modelContainer(container)
        }
    }
#endif
