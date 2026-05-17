//
//  CategoryFinishedView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 14.05.26.
//

import SwiftUI

struct CategoryFinishedView: View {
    let categoryName: String
    let onRestart: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)

                Text("Category Complete!")
                    .font(.title)
                    .fontWeight(.bold)

                Text(
                    "You've completed all challenges in \(categoryName). What's next?"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .padding(.top, 40)

            VStack(spacing: 16) {
                Button {
                    onRestart()
                    dismiss()
                } label: {
                    Label("Restart Challenges", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    onArchive()
                    dismiss()
                } label: {
                    Label("Archive Category", systemImage: "archivebox")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Category", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .alert("Delete \(categoryName)?", isPresented: $showDeleteConfirmation)
        {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "This will permanently delete the category and all its challenges."
            )
        }
    }
}

#Preview {
    CategoryFinishedView(
        categoryName: "Fitness",
        onRestart: {},
        onArchive: {},
        onDelete: {}
    )
}
