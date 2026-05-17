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
            CategoryGradient(
                rawValue: viewModel.challenge.category.gradientName
            )?.gradient
                .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "lightbulb.max")
                                .font(.title)

                            Text("Concept Explanation")
                        }
                        Text(viewModel.challenge.conceptExplanation)

                        HStack {
                            Image(systemName: "dot.scope")
                                .font(.title)

                            Text("Challenge:")
                        }
                        Text(viewModel.challenge.taskDescription)

                        Divider()

                        Button {
                            viewModel.markComplete()
                            if !viewModel.showCycleCompleteSheet {
                                dismiss()
                            }
                        } label: {
                            Label("Completed", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(.thickMaterial.opacity(0.6))
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
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

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

//#Preview {
//    let container = PreviewHelper.container
//    let category = PreviewHelper.makeCategory()
//    let challenge = PreviewHelper.makeChallenge(for: category)
//    NavigationStack {
//        ChallengeDetailsView(challenge: challenge)
//    }
//    .modelContainer(container)
//}
