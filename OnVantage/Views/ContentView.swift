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
    @Query var categories: [Category]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("\(categories.first?.colorHex)")
        }
        .padding()
        .onAppear {
            SeedImporter.loadSeedData(context: modelContext)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    let container = try! ModelContainer(
        for: Category.self,
        CategoryProgress.self,
        Challenge.self,
        ChallengeAttempt.self,
        configurations: config
    )

    ContentView()
        .modelContainer(container)
}
