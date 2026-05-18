//
//  ChallengeCardView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 9.05.26.
//

import SwiftData
import SwiftUI

struct ChallengeCardView: View {
    @Bindable var challenge: Challenge
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // MARK: Difficulty dots
            VStack(spacing: 4) {
                ForEach(1...3, id: \.self) { level in
                    Circle()
                        .fill(
                            level <= challenge.difficulty
                                ? Color.primary
                                : Color.primary.opacity(0.15)
                        )
                        .frame(width: 9, height: 9)
                }
            }
            .padding(.top, 4)

            // MARK: Content
            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(challenge.taskDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            // MARK: Edit button
            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 14))
        .padding(.horizontal)
        .contextMenu {
            Button("Edit") { onEdit() }
            Button("Delete", role: .destructive) { onDelete() }
        }
    }
}

#if DEBUG
    private struct PreviewHelperView<Content: View>: View {
        @Query var challenges: [Challenge]
        let content: (Challenge) -> Content

        var body: some View {
            if let challenge = challenges.first {
                content(challenge)
            }
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeed_seed_swiftui")
        SeedImporter.loadSeedData(
            context: container.mainContext,
            resource: "seed_swiftui"
        )

        return NavigationStack {
            PreviewHelperView { challenge in
                ChallengeCardView(
                    challenge: challenge,
                    onEdit: {},
                    onDelete: {}
                )
                .background(CategoryGradient.fire.gradient)
            }
            .modelContainer(container)
        }
    }
#endif
