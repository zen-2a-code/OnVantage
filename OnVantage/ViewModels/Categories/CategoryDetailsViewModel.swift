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
        var showAddModifyChallengeSheet: Bool = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func requestDelete(_ challenge: Challenge){
            showDeleteAlert = true
            challengeToModify = challenge
        }
        
        func requestAdd() {
            challengeToModify = nil
            showAddModifyChallengeSheet = true
        }
        
        func confirmDelete() {
            guard let challengeToModify = challengeToModify else { return }
            
            if let progress = challengeToModify.category.progress {
                CycleManager.handleChallengeRemoved(challengeToModify, forCategoryProgress: progress)
            }

            modelContext.delete(challengeToModify)
            try? self.modelContext.save()
            
            self.challengeToModify = nil
            self.showDeleteAlert = false
        }
        
        func requestEdit(_ challenge: Challenge) {
            challengeToModify = challenge
            showAddModifyChallengeSheet = true
        }
    }
}
