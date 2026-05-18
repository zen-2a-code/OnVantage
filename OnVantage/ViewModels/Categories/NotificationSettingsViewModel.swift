//
//  NotificationSettingsViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import Foundation
import SwiftUI

extension NotificationSettingsView {
    @Observable
    class ViewModel {
        var isEnabled: Bool
        var selectedTime: Date
        var showDeniedAlert: Bool = false

        private let category: ChallengeCategory

        init(category: ChallengeCategory) {
            self.category = category

            let progress = category.progress
            isEnabled = progress?.notificationEnabled ?? false

            var components = DateComponents()
            components.hour = progress?.notificationHour ?? 8
            components.minute = progress?.notificationMinute ?? 0
            selectedTime =
                Calendar.current.date(from: components) ?? Date()
        }

        func save() async {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: selectedTime)
            let minute = calendar.component(.minute, from: selectedTime)

            if isEnabled {
                let granted = await NotificationService.schedule(
                    categoryId: category.id,
                    categoryName: category.name,
                    hour: hour,
                    minute: minute
                )

                if granted {
                    category.progress?.notificationEnabled = true
                    category.progress?.notificationHour = hour
                    category.progress?.notificationMinute = minute
                } else {
                    showDeniedAlert = true
                }
            } else {
                NotificationService.cancel(categoryId: category.id)
                category.progress?.notificationEnabled = false
                category.progress?.notificationHour = nil
                category.progress?.notificationMinute = nil
            }
        }
    }
}
