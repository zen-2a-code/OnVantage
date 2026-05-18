//
//  CategoryCardView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 7.05.26.
//

import SwiftData
import SwiftUI

struct CategoryCardView: View {
    @Bindable var category: ChallengeCategory
    let onRequestDelete: () -> Void
    let onSetActive: (Bool) -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                (CategoryGradient(rawValue: category.gradientName) ?? .fallback)
                    .gradient
            )
            .grayscale(category.isActive ? 0 : 1.0)
            .shadow(radius: 6)
            .frame(height: 150)
            .overlay {
                VStack(alignment: .leading, spacing: 10) {

                    // MARK: Name + Toggle
                    HStack {
                        Image(systemName: category.iconName)
                            .font(.title2)
                        Text(category.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Spacer()
                        Toggle("", isOn: $category.isActive)
                            .labelsHidden()
                            .tint(.white.opacity(0.8))
                            .onChange(of: category.isActive) { _, newValue in
                                onSetActive(newValue)
                            }
                    }

                    // MARK: Streaks
                    HStack(spacing: 14) {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                            Text("\(category.progress?.currentStreak ?? 0)")
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.yellow)
                            Text("\(category.progress?.longestStreak ?? 0)")
                        }
                    }
                    .font(.subheadline)

                    // MARK: Progress
                    if let progress = category.progress,
                        progress.totalChallenges > 0
                    {
                        HStack(spacing: 8) {
                            ProgressView(
                                value: Double(progress.totalChallengesCompleted),
                                total: Double(progress.totalChallenges)
                            )
                            .tint(.white)
                            Text(
                                "\(progress.totalChallengesCompleted)/\(progress.totalChallenges)"
                            )
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
            .contextMenu {
                Button("Delete", role: .destructive) {
                    onRequestDelete()
                }
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

    CategoryCardView(
        category: category,
        onRequestDelete: {},
        onSetActive: { _ in }
    )
    .padding()
    .modelContainer(PreviewHelper.container)
}
