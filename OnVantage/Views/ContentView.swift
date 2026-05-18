//
//  ContentView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(DeepLinkHandler.self) private var deepLinkHandler

    var body: some View {
        @Bindable var deepLinkHandler = deepLinkHandler
        TabView(selection: $deepLinkHandler.selectedTab) {
            HomeView(modelContext: modelContext)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            CategoriesView(modelContext: modelContext)
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .onAppear {
            SeedImporter.loadSeedData(context: modelContext, resource: "seed_swiftui")
            SeedImporter.loadSeedData(
                context: modelContext,
                resource: "wim_hof_challenges"
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    let container = try! ModelContainer(
        for: ChallengeCategory.self,
        CategoryProgress.self,
        Challenge.self,
        ChallengeAttempt.self,
        configurations: config
    )

    ContentView()
        .modelContainer(container)
        .environment(DeepLinkHandler())
}
