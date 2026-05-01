//
//  CategoryProgress.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation
import SwiftData

@Model
class CategoryProgress {
    var id = UUID()
    var category: Category
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastCompletedDate: Date?
    var lastActivityDate: Date?
    var totalCompleted: Int = 0
    var skipsRemainingThisCycle: Int = 3
    var cycleStartedAt: Date
    var cycleNumber: Int = 1
    var shuffledOrder: [UUID] = []
    var isOrdered: Bool
    var notificationEnabled: Bool = false
    var notificationHour: Int?
    var notificationMinute: Int?

    init(id: UUID = UUID(), category: Category, lastCompletedDate: Date? = nil, cycleStartedAt: Date, shuffledOrder: [UUID] = [], isOrdered: Bool = false, notificationEnabled: Bool = false, notificationHour: Int? = nil, notificationMinute: Int? = nil) {
        self.id = id
        self.category = category
        self.lastCompletedDate = lastCompletedDate
        self.cycleStartedAt = cycleStartedAt
        self.shuffledOrder = shuffledOrder
        self.isOrdered = isOrdered
        self.notificationEnabled = notificationEnabled
        self.notificationHour = notificationHour
        self.notificationMinute = notificationMinute
    }
}
