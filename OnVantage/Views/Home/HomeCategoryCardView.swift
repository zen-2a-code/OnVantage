//
//  HomeCategoryCardView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI

struct HomeCategoryCardView: View {
    let category: ChallengeCategory
    let challenge: Challenge?
    let hasChallenge: Bool
    let statusText: String
    let hourGlassRotationAngle: Double
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: category.iconName)
                        .font(.title2)
                    Text(category.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }

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

                if let progress = category.progress, progress.totalChallenges > 0 {
                    VStack(spacing: 4) {
                        ProgressView(
                            value: Double(progress.totalChallengesCompleted),
                            total: Double(progress.totalChallenges)
                        )
                        .tint(.white)
                        Text(
                            "\(progress.totalChallengesCompleted) / \(progress.totalChallenges) this cycle"
                        )
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Group {
                if hasChallenge, let challenge {
                    VStack(spacing: 12) {
                        NavigationLink(value: challenge) {
                            VStack(spacing: 10) {
                                Text(statusText)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Image(systemName: "hourglass.bottomhalf.filled")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                    .rotationEffect(.degrees(hourGlassRotationAngle))

                                HStack(spacing: 6) {
                                    Text("Start Challenge")
                                        .fontWeight(.medium)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.white.opacity(0.35))
                                .clipShape(Capsule())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .foregroundStyle(.primary)

                        Button(role: .destructive, action: onSkip) {
                            Text(
                                "Skip (\(category.progress?.skipsRemainingThisCycle ?? 0) left)"
                            )
                            .font(.caption)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())
                        }
                        .disabled(
                            (category.progress?.skipsRemainingThisCycle ?? 0) == 0
                        )
                        .padding(.bottom, 12)
                    }
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "hands.and.sparkles")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("Done for today!")
                            .font(.headline)
                        Text(statusText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
            }
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background(CategoryGradient(rawValue: category.gradientName)?.gradient)
        .clipShape(.rect(cornerRadius: 20))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
