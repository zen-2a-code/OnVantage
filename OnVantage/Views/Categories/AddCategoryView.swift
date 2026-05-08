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
                TextField("Name", text: $viewModel.name)

                Section("Style") {
                    Picker("Category icon", selection: $viewModel.iconName) {
                        ForEach(AppConstants.categoryIcons, id: \.self) {
                            currentIcon in
                            Label(
                                currentIcon.split(separator: ".").first.map {
                                    $0.capitalized
                                } ?? "",
                                systemImage: currentIcon
                            )
                            .tag(currentIcon)
                        }
                    }
                    .pickerStyle(.wheel)

                    let columns = Array(
                        repeating: GridItem(.flexible()),
                        count: 5
                    )

                    Text("Category color")
                    LazyVGrid(columns: columns) {
                        ForEach(CategoryGradient.allCases) { gradient in
                            Circle()
                                .fill(gradient.gradient)
                                .frame(width: 44)
                                .overlay(
                                    gradient.rawValue == viewModel.gradientName
                                        ? Circle().stroke(.black, lineWidth: 3)
                                        : nil
                                )
                                .onTapGesture {
                                    viewModel.gradientName = gradient.rawValue
                                }
                        }
                    }

                    Button("Add") {
                        viewModel.addNewCategory()
                        dismiss()
                    }
                    .disabled(viewModel.isAddNewCategoryDisabled())

                }
            }
            .navigationTitle("Add new category")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddCategoryView(modelContext: PreviewHelper.container.mainContext)
        .modelContainer(PreviewHelper.container)
}
