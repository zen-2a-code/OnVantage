//
//  AddModifyChallengeView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 10.05.26.
//

import SwiftData
import SwiftUI

struct AddModifyChallengeView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    var challenge: Challenge?

    init(
        modelContext: ModelContext,
        category: ChallengeCategory,
        challenge: Challenge? = nil
    ) {
        self._viewModel = State(
            initialValue: ViewModel(
                modelContext: modelContext,
                category: category,
                challenge: challenge
            )
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Title:") {
                        TextField(
                            "Enter title",
                            text: $viewModel.title,
                            prompt: Text("Enter title")
                        )
                    }
                    Stepper(
                        "Difficulty: \(viewModel.difficulty)",
                        value: $viewModel.difficulty,
                        in: 1...3
                    )
                }
                .listRowBackground(Color.white.opacity(0.7))

                Section("Challenge information") {
                    VStack {
                        Text("Concept Explanation")
                            .foregroundStyle(.secondary)
                        TextEditor(text: $viewModel.conceptExplanation)
                            .frame(minHeight: 30)
                    }

                    VStack {
                        Text("Challenge")
                            .foregroundStyle(.secondary)
                        TextEditor(text: $viewModel.taskDescription)
                            .frame(minHeight: 30)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white.opacity(0.7))
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(
                CategoryGradient(rawValue: viewModel.category.gradientName)?
                    .gradient.opacity(0.6)
                    .ignoresSafeArea()
            )
            .navigationTitle(viewModel.navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.save()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(
                                viewModel.isSaveDisabled ? .gray : .green
                            )
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }

        }
    }
}

#Preview {
    let container = PreviewHelper.container
    let category = PreviewHelper.makeCategory()
    let challenge = PreviewHelper.makeChallenge(for: category)
    //        AddModifyChallengeView(modelContext: container.mainContext, category: category)
    AddModifyChallengeView(
        modelContext: container.mainContext,
        category: category,
        challenge: challenge
    )
    .modelContainer(container)
}
