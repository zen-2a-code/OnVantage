//
//  CategoryDetailsViewModel.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 10.05.26.
//

import SwiftUI
import SwiftData

extension CategoryDetailsView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var challengeToModify: Challenge?
        var showDeleteAlert: Bool = false
        var showEditSheet: Bool = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func requestDelete(_ challenge: Challenge){
            showDeleteAlert = true
            challengeToModify = challenge
        }
        
        func confirmDelete() {
            guard let challengeToModify = challengeToModify else { return }
            modelContext.delete(challengeToModify)
            self.challengeToModify = nil
        }
        
        func requestEdit(_ challenge: Challenge) {
            challengeToModify = challenge
            showEditSheet = true
        }
    }
}
