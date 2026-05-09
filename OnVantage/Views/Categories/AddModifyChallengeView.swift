//
//  AddModifyChallengeView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 10.05.26.
//

import SwiftData
import SwiftUI

struct AddModifyChallengeView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    var challenge: Challenge?
    
    init(modelContext: ModelContext, category: ChallengeCategory, challenge: Challenge? = nil) {
        self._viewModel = State(initialValue: ViewModel(
            modelContext: modelContext,
            category: category,
            challenge: challenge
        ))
    }
    
    var body: some View {
        NavigationStack {
            List {

            }
            .navigationTitle(viewModel.navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {

                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }
}

#Preview {
    let container = PreviewHelper.container
    let category = PreviewHelper.makeCategory()
    let challenge = PreviewHelper.makeChallenge(for: category)
//    AddModifyChallengeView(modelContext: container.mainContext, category: category)
    AddModifyChallengeView(modelContext: container.mainContext, category: category, challenge: challenge)
        .modelContainer(container)
}
