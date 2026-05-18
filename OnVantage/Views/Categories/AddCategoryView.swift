//
//  AddCategoryView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 8.05.26.
//

import SwiftData
import SwiftUI

struct AddCategoryView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init(modelContext: ModelContext) {
        self._viewModel = State(
            initialValue: ViewModel(modelContext: modelContext)
        )
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                    Toggle("Random challenge order", isOn: $viewModel.isShuffleEnabled)
                }

                Section("Style") {
                    Text("Icon")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    IconPickerView(selection: $viewModel.selectedIconName)
                        .padding(.vertical, 4)

                    Text("Color")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    GradientPickerView(selection: $viewModel.selectedGradient)
                        .padding(.vertical, 4)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addNewCategory()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(
                                viewModel.isAddNewCategoryDisabled() ? .gray : .green
                            )
                    }
                    .disabled(viewModel.isAddNewCategoryDisabled())
                }
            }
        }
    }
}

#Preview {
    AddCategoryView(modelContext: PreviewHelper.container.mainContext)
        .modelContainer(PreviewHelper.container)
}
