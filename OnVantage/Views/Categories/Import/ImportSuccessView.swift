//
//  ImportSuccessView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI

struct ImportSuccessView: View {
    let count: Int
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)
            Text("Import Complete!")
                .font(.title2).fontWeight(.bold)
            Text(
                "\(count) challenge\(count == 1 ? "" : "s") imported successfully."
            )
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ImportSuccessView(count: 12, onDone: {})
}
