//
//  ImportErrorView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftData
import SwiftUI

struct ImportErrorView: View {
    let message: String
    var viewModel: ImportCategoryView.ViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.red)
            Text("Import Failed")
                .font(.title2).fontWeight(.bold)
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") { viewModel.reset() }
                .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ImportErrorView(
        message: "Difficulty must be between (including) 1–3. Found: 5.",
        viewModel: ImportCategoryView.ViewModel(
            modelContext: PreviewHelper.container.mainContext
        )
    )
    .modelContainer(PreviewHelper.container)
}
