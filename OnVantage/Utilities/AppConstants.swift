//
//  AppConstants.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 28.04.26.
//

import Foundation

enum AppConstants: CaseIterable {
    static let categoryColors: [String] = [
        "#007AFF", // Blue
        "#FF3B30", // Red
        "#34C759", // Green
        "#FF9500", // Orange
        "#AF52DE", // Purple
        "#FF2D55", // Pink
        "#5856D6", // Indigo
        "#00C7BE", // Teal
        "#32ADE6", // Cyan
        "#FFCC00", // Yellow
        "#A2845E", // Brown
        "#FF6B35"  // Coral
    ]
    
    static let categoryIcons: [String] = [
        "star.fill",            // favourites, goals, anything important
        "book.fill",            // learning, reading, study
        "heart.fill",           // health, relationships, self-care
        "bolt.fill",            // habits, energy, productivity
        "dumbbell.fill",        // fitness, sport, physical
        "music.note",           // music, creative, audio
        "paintbrush.fill",      // art, design, creative
        "fork.knife",           // food, cooking, nutrition
        "house.fill",           // home, chores, domestic
        "briefcase.fill",       // work, career, business
        "globe.europe.africa", // language, travel, geography
        "brain.fill",           // mental health, mindfulness, thinking ( iOS 18+ )
        "calendar",             // planning, routines, scheduling
        "message.fill",         // communication, social, relationships
        "leaf.fill"             // nature, wellness, sustainability
    ]
}
