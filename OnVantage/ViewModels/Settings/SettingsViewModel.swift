//
//  SettingsViewModel.swift
//  OnVantage
//

import SwiftData
import SwiftUI

extension SettingsView {
    @Observable
    class ViewModel {
        var showReseedAlert: Bool = false
        var modelContext: ModelContext

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func openLanguageSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString)
            else { return }
            UIApplication.shared.open(url)
        }

        /// Resets the seed flags and re-imports both seed files.
        /// Does not delete any existing data.
        func reseedData() {
            UserDefaults.standard.removeObject(forKey: "didSeed_seed_swiftui")
            UserDefaults.standard.removeObject(
                forKey: "didSeed_wim_hof_challenges"
            )
            SeedImporter.loadSeedData(
                context: modelContext,
                resource: "seed_swiftui"
            )
            SeedImporter.loadSeedData(
                context: modelContext,
                resource: "wim_hof_challenges"
            )
        }
    }
}
