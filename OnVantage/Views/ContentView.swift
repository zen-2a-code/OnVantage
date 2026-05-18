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
    var body: some View {
        TabView {
            HomeView(modelContext: modelContext)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            CategoriesView(modelContext: modelContext)
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear {
            SeedImporter.loadSeedData(context: modelContext)
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
}
