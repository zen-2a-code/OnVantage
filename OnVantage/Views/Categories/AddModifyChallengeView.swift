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
                    TextField("Title", text: $viewModel.title)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Difficulty")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker("Difficulty", selection: $viewModel.difficulty) {
                            Text("Easy").tag(1)
                            Text("Medium").tag(2)
                            Text("Hard").tag(3)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .listRowBackground(Color.white.opacity(0.7))

                Section("Challenge Information") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Concept Explanation")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $viewModel.conceptExplanation)
                            .frame(minHeight: 80)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Task Description")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $viewModel.taskDescription)
                            .frame(minHeight: 80)
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

#if DEBUG
    #Preview("Add") {
        let container = PreviewHelper.container
        let category = PreviewHelper.makeCategory()
        return AddModifyChallengeView(
            modelContext: container.mainContext,
            category: category
        )
        .modelContainer(container)
    }

    #Preview("Edit") {
        let container = PreviewHelper.container
        let category = PreviewHelper.makeCategory()
        let challenge = PreviewHelper.makeChallenge(for: category)
        return AddModifyChallengeView(
            modelContext: container.mainContext,
            category: category,
            challenge: challenge
        )
        .modelContainer(container)
    }
#endif
