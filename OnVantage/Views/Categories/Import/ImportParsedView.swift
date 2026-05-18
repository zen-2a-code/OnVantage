//
//  ImportParsedView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftData
import SwiftUI

struct ImportParsedView: View {
    let dto: ImportedCategoryDTO
    @Bindable var viewModel: ImportCategoryView.ViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    private var isConfirmDisabled: Bool {
        viewModel.categoryName.trimmingCharacters(in: .whitespaces).count < 3
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category Name")
                        .font(.headline)
                    TextField("Name", text: $viewModel.categoryName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Color")
                        .font(.headline)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(CategoryGradient.allCases) { gradient in
                            Circle()
                                .fill(gradient.gradient)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    viewModel.selectedGradient == gradient
                                        ? Circle().stroke(.black, lineWidth: 3)
                                        : nil
                                )
                                .onTapGesture {
                                    viewModel.selectedGradient = gradient
                                }
                        }
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Icon")
                        .font(.headline)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(AppConstants.categoryIcons, id: \.self) {
                            icon in
                            let isSelected = viewModel.selectedIconName == icon
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(
                                    isSelected
                                        ? Color.accentColor.opacity(0.15)
                                        : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    isSelected
                                        ? RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                Color.accentColor,
                                                lineWidth: 2
                                            )
                                        : nil
                                )
                                .onTapGesture {
                                    viewModel.selectedIconName = icon
                                }
                        }
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Challenges")
                            .font(.headline)
                        Spacer()
                        Text(
                            "\(dto.challenges.count) · \(dto.isOrdered ? "Ordered" : "Random")"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    ForEach(Array(dto.challenges.enumerated()), id: \.offset) {
                        index,
                        challenge in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 22, alignment: .leading)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(challenge.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(challenge.taskDescription)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer()

                            HStack(spacing: 3) {
                                ForEach(1...3, id: \.self) { level in
                                    Circle()
                                        .fill(
                                            level <= challenge.difficulty
                                                ? Color.accentColor
                                                : Color.gray.opacity(0.25)
                                        )
                                        .frame(width: 7, height: 7)
                                }
                            }
                        }
                        .padding(.vertical, 4)

                        if index < dto.challenges.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(16)

                HStack(spacing: 12) {
                    Button("Cancel") { viewModel.reset() }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)

                    Button("Import") { viewModel.confirmImport(dto: dto) }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .disabled(isConfirmDisabled)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let dto = ImportedCategoryDTO(
        categoryName: "Mindfulness",
        isOrdered: false,
        challenges: [
            ImportedChallengeDTO(
                title: "Morning Breathing",
                conceptExplanation:
                    "Deep breathing activates the parasympathetic nervous system, reducing cortisol and improving focus. Starting your day with intentional breath sets a calm tone.",
                taskDescription:
                    "Do 4 rounds of box breathing: inhale 4s, hold 4s, exhale 4s, hold 4s.",
                difficulty: 1
            ),
            ImportedChallengeDTO(
                title: "Body Scan Meditation",
                conceptExplanation:
                    "A body scan brings awareness to physical sensations, helping release tension you may not notice. It trains attention and reduces stress.",
                taskDescription:
                    "Lie down for 10 minutes and slowly scan from your toes to the top of your head.",
                difficulty: 2
            ),
            ImportedChallengeDTO(
                title: "Cold Shower",
                conceptExplanation:
                    "Cold exposure activates the sympathetic nervous system and releases norepinephrine, improving mood and alertness.",
                taskDescription:
                    "End your shower with 60 seconds of cold water.",
                difficulty: 3
            ),
        ]
    )
    let viewModel = ImportCategoryView.ViewModel(
        modelContext: PreviewHelper.container.mainContext
    )
    return ImportParsedView(dto: dto, viewModel: viewModel)
        .modelContainer(PreviewHelper.container)
}
