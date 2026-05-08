//
//  CategoryGradient.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 5.05.26.
//

import SwiftUI

enum CategoryGradient: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case ocean, sunset, forest, aurora, candy,
         dusk, fire, mint, rose, midnight,
         peach, storm, lavender, gold, jade

    var gradient: LinearGradient {
        switch self {
        case .ocean:
            return make("#0077B6", "#00B4D8")
        case .sunset:
            return make("#F72585", "#FF9A00")
        case .forest:
            return make("#1B4332", "#52B788")
        case .aurora:
            return make("#7B2FBE", "#00C9A7")
        case .candy:
            return make("#FF6B9D", "#C44EFF")
        case .dusk:
            return make("#2D3561", "#C05C7E")
        case .fire:
            return make("#E63946", "#FF9F1C")
        case .mint:
            return make("#00B09B", "#96C93D")
        case .rose:
            return make("#FF758C", "#FF7EB3")
        case .midnight:
            return make("#141E30", "#243B55")
        case .peach:
            return make("#FFAA85", "#FF6B6B")
        case .storm:
            return make("#182848", "#4B6CB7")
        case .lavender:
            return make("#A18CD1", "#FBC2EB")
        case .gold:
            return make("#F7971E", "#FFD200")
        case .jade:
            return make("#11998E", "#38EF7D")
        }
    }

    var displayName: String { rawValue.capitalized }

    static var fallback: CategoryGradient { .ocean }

    private func make(_ start: String, _ end: String) -> LinearGradient {
        LinearGradient(
            colors: [Color(hex: start), Color(hex: end)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
