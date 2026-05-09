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
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            VStack {
                Text(challenge.title)
                    .font(.title3)
                    .fontDesign(.monospaced)
                    .multilineTextAlignment(.center)
                
                Text("Difficulty: \(challenge.difficulty) of 3")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            

            Divider()

            VStack(spacing: 6) {
                Text("Concept Explanation")
                    .fontDesign(.serif)
                    .font(.subheadline)
                Text(challenge.conceptExplanation)

            }

            VStack(spacing: 6) {
                Text("Challenge")
                    .fontDesign(.serif)
                    .font(.title2)
                Text(challenge.taskDescription)
                    .font(.body)
            }

            Divider()
            HStack(spacing: 25) {
                Button {

                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive) {

                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }

                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.7))
        )
        .padding()
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
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

        return NavigationStack {
            PreviewHelperView { challenge in
                ChallengeCardView(challenge: challenge)
                    .background(CategoryGradient.fire.gradient)
            }
            .modelContainer(container)
        }
    }
#endif

#Preview {
    var container = PreviewHelper.container
    var category = PreviewHelper.makeCategory()
    var challenge = PreviewHelper.makeChallenge(for: category)
    ChallengeCardView(challenge: challenge)
        .modelContainer(container)
}
