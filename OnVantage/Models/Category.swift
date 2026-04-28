//
//  Category.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import SwiftData
import Foundation

@Model
class Category {
    var id = UUID()
    var name: String
    var colorHex: String
    var iconName: String
    var isActive: Bool
    var isUserCreated: Bool
    var createdAt: Date
    var challenges: [Challenge]
    var progress: CategoryProgress?
    
    init(id: UUID = UUID(), name: String, colorHex: String, iconName: String, isActive: Bool, isUserCreated: Bool, createdAt: Date, challenges: [Challenge], progress: CategoryProgress? = nil) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
        self.isActive = isActive
        self.isUserCreated = isUserCreated
        self.createdAt = createdAt
        self.challenges = challenges
        self.progress = progress
    }
}
