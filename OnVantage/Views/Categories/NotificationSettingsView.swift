//
//  NotificationSettingsView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI
import SwiftData

struct NotificationSettingsView: View {
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init(category: ChallengeCategory) {
        self._viewModel = State(initialValue: ViewModel(category: category))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Daily Reminder", isOn: $viewModel.isEnabled)
                }

                if viewModel.isEnabled {
                    Section("Reminder Time") {
                        DatePicker(
                            "Time",
                            selection: $viewModel.selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: viewModel.isEnabled)
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
                        Task {
                            await viewModel.save()
                            if !viewModel.showDeniedAlert {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                }
            }
            .alert("Notifications Disabled", isPresented: $viewModel.showDeniedAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "Please enable notifications for OnVantage in Settings to use this feature."
                )
            }
        }
    }
}

#if DEBUG
    #Preview {
        let container = PreviewHelper.container
        let category = PreviewHelper.makeCategory(name: "Fitness")
        let _ = PreviewHelper.makeProgress(for: category)
        return NotificationSettingsView(category: category)
            .modelContainer(container)
    }
#endif
