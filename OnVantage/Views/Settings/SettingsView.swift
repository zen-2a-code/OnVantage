//
//  SettingsView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ViewModel

    init() {
        // modelContext isn't available yet at init time — we set a placeholder
        // and replace it in .onAppear
        self._viewModel = State(
            initialValue: ViewModel(
                modelContext: ModelContext(
                    try! ModelContainer(for: ChallengeCategory.self)
                )
            )
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Language") {
                    Button {
                        viewModel.openLanguageSettings()
                    } label: {
                        HStack {
                            Text("App Language")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("🇧🇬  🇬🇧")
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }

                Section("Data") {
                    Button("Reseed Sample Data", role: .destructive) {
                        viewModel.showReseedAlert = true
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel = ViewModel(modelContext: modelContext)
            }
            .alert(
                "Reseed Sample Data?",
                isPresented: $viewModel.showReseedAlert
            ) {
                Button("Reseed", role: .destructive) {
                    viewModel.reseedData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "This will add the SwiftUI and Wim Hof sample categories again. Your existing data will not be affected."
                )
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(PreviewHelper.container)
}
