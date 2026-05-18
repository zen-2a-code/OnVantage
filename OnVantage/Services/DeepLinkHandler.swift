//
//  DeepLinkHandler.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import Foundation

/// Shared state that bridges notification taps to SwiftUI navigation.
/// Injected into the environment at the App level so any view can read it.
@Observable
class DeepLinkHandler {
    var selectedTab: Int = 0
    var pendingCategoryId: UUID? = nil
}
