//
//  CategoryCardView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 7.05.26.
//

import SwiftUI
import SwiftData

struct CategoryCardView: View {
    @Bindable var category: ChallengeCategory
    let onRequestDelete: () -> Void
       let onSetActive: (Bool) -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                (CategoryGradient(
                    rawValue: category.gradientName
                ) ?? .fallback).gradient
            ).grayscale(category.isActive ? 0 : 1.0)
            .shadow(radius: 10)
            .frame(height: 160)
            .overlay {
                VStack(spacing: 5) {
                    HStack {
                        Text(category.name)
                            .font(.largeTitle)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        Button("Delete", role: .destructive) {
                            onRequestDelete()
                        }
                            .font(.caption2)
                            .buttonStyle(.borderedProminent)
                            .bold()
                            .foregroundStyle(.white)

                        Spacer()

                        Image(systemName: "bell.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow)
                            .font(.title)
                    }

                    VStack(spacing: 10) {
                        HStack(spacing: 20) {
                            Toggle(
                                "Active",
                                isOn: $category.isActive
                            )
                            .frame(width: 120)
                            .scaleEffect(0.8)
                            .frame(width: 120 * 0.8)
                            .onChange(of: category.isActive) { _, newValue in
                                onSetActive(newValue)
                            }

                            Spacer()
                        }

                        HStack(spacing: 10) {
                            Image(systemName: category.iconName)
                                .font(.title2)
                            if let progress = category.progress {
                                Text("Challenges \(progress.totalChallengesCompleted)/\(progress.totalChallenges)")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Challenges 0/\(category.challenges.count)")
                            }
                        }
                    }
                }
                .padding()
            }
    }
}

#Preview {
    let category = PreviewHelper.makeCategory(name: "Fitness")
    let progress = PreviewHelper.makeProgress(for: category)
    let _ = PreviewHelper.makeChallenge(for: category)
    let _ = {CycleManager.buildQueue(for: progress)}()
    let _ = {category.challenges.first!.attempts.append(ChallengeAttempt(startedAt: .now, status: .completed))}()
    
    CategoryCardView(category: category, onRequestDelete: {
    }, onSetActive: {isActive in } )
    .modelContainer(PreviewHelper.container)
}
