//
//  ImportCategoryView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct ImportCategoryView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init(modelContext: ModelContext) {
        self._viewModel = State(
            initialValue: ViewModel(modelContext: modelContext)
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    ImportIdleView(viewModel: viewModel)
                case .parsed(let dto):
                    ImportParsedView(dto: dto, viewModel: viewModel)
                case .success(let count):
                    ImportSuccessView(count: count, onDone: { dismiss() })
                case .error(let message):
                    ImportErrorView(message: message, viewModel: viewModel)
                }
            }
            .navigationTitle("Import Category")
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
            }
        }
        .fileImporter(
            isPresented: $viewModel.showFilePicker,
            allowedContentTypes: [UTType.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                let gotAccess = url.startAccessingSecurityScopedResource()
                defer {
                    if gotAccess { url.stopAccessingSecurityScopedResource() }
                }
                viewModel.handleFileSelection(url)
            case .failure(let error):
                viewModel.state = .error(error.localizedDescription)
            }
        }
    }
}
