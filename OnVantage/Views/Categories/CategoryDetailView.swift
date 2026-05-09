//
//  CategoryDetailView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import SwiftData
import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: ChallengeCategory
    var body: some View {
        List {
            Section {
                if let progress = category.progress {
                    HStack {
                        Image(systemName: progress.orderModeIcon)
                        Text("Challenges order - \(progress.orderModeLabel)")
                    }
                }

                Text(
                    "Category created on: \(category.createdAt, format: .dateTime)"
                )
            }
            .listRowBackground(Color.white.opacity(0.7))

            if !category.challenges.isEmpty {
                ForEach(category.challenges) { challenge in
                    Section(challenge.title) {
                        VStack {
                            Text("Title")
                                .font(.caption)
                                .fontDesign(.serif)
                            Text(challenge.title)
                        }
                        VStack {
                            Text("Description")
                                .font(.caption)
                                .fontDesign(.serif)
                            Text(challenge.taskDescription)
                        }
                        VStack {
                            Text("Concept Explanation")
                                .font(.caption)
                                .fontDesign(.serif)
                            Text(challenge.conceptExplanation)
                        }
                        Button(role: .destructive) {

                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.white.opacity(0.7))
                }

            } else {
                ContentUnavailableView(
                    "No challenges",
                    systemImage: "flag.slash"
                )
                .listRowBackground(Color.white.opacity(0.7))
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            (CategoryGradient(rawValue: category.gradientName) ?? .fallback)
                .gradient
        )
        .navigationTitle($category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem {
                Button {

                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#if DEBUG
    struct PreviewHelperView<Content: View>: View {
        @Query var categories: [ChallengeCategory]
        let content: (ChallengeCategory) -> Content

        var body: some View {
            if let category = categories.first {
                content(category)
            }
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

        return NavigationStack {
            PreviewHelperView { category in
                CategoryDetailView(category: category)
            }
            .modelContainer(container)
        }
    }
#endif

#Preview {
    let container = PreviewHelper.container
    let category = PreviewHelper.makeCategory()
    let _ = { category.gradientName = CategoryGradient.rose.rawValue }()
    let progress = PreviewHelper.makeProgress(for: category)
    let _ = { progress.isOrdered = true }()
    let challenge = PreviewHelper.makeChallenge(for: category)
    let challenge2 = PreviewHelper.makeChallenge(for: category)
    NavigationStack {
        CategoryDetailView(category: category)
            .modelContainer(container)
    }
}
