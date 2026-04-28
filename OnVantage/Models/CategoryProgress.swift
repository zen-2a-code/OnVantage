//
//  CategoryProgress.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import Foundation

@Model
class CategoryProgress {
    var id = UUID()
    var category: Category
    var currentStreak: Int
    var longestStreak: Int
    var lastCompletedDate: Date?
    var totalCompleted: Int
    var skipsRemainingThisCycle: Int
    var cycleStartedAt: Date
    var cycleNumber: Int
    var shuffledOrder: [UUID]
    var notificationEnabled: Bool
    var notificationHour: Int?
    var notificationMinute: Int?
    
    init(id: UUID = UUID(), category: Category, currentStreak: Int, longestStreak: Int, lastCompletedDate: Date? = nil, totalCompleted: Int, skipsRemainingThisCycle: Int, cycleStartedAt: Date, cycleNumber: Int, shuffledOrder: [UUID], notificationEnabled: Bool, notificationHour: Int? = nil, notificationMinute: Int? = nil) {
        self.id = id
        self.category = category
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastCompletedDate = lastCompletedDate
        self.totalCompleted = totalCompleted
        self.skipsRemainingThisCycle = skipsRemainingThisCycle
        self.cycleStartedAt = cycleStartedAt
        self.cycleNumber = cycleNumber
        self.shuffledOrder = shuffledOrder
        self.notificationEnabled = notificationEnabled
        self.notificationHour = notificationHour
        self.notificationMinute = notificationMinute
    }
}

