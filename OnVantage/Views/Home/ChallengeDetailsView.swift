//
//  ChallengeDetailsView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 13.05.26.
//

import SwiftData
import SwiftUI

struct ChallengeDetailsView: View {
    var challenge: Challenge
    var body: some View {
        ZStack {
            CategoryGradient(rawValue: "ocean")?.gradient
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "lightbulb.max")
                                .font(.title)
                            
                            Text("Concept Explanation")
                        }
                        Text(challenge.conceptExplanation)
                        
                        HStack {
                            Image(systemName: "dot.scope")
                                .font(.title)
                            
                            Text("Challenge:")
                        }
                        Text(challenge.taskDescription)
                        
                        Divider()
                        
                        Button {
                            
                        } label: {
                            Text("Completed")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(.thickMaterial.opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    
                    
                }
            }
        }
        .navigationTitle(challenge.title)
        .navigationBarTitleDisplayMode(.inline)
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
                ChallengeDetailsView(
                    challenge: challenge
                )
            }
            .modelContainer(container)
        }
    }
#endif

#Preview {
    let container = PreviewHelper.container
    let category = PreviewHelper.makeCategory()
    let challenge = PreviewHelper.makeChallenge(for: category)
    NavigationStack {
        ChallengeDetailsView(challenge: challenge)
    }
    .modelContainer(container)
}
