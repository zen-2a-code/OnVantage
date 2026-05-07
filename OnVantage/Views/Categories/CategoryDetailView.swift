//
//  CategoryDetailView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

import SwiftData
import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: Category
    var body: some View {
        List {
            TextField("Enter category name", text: $category.name)
        }
    }
}

#Preview {
    let category = PreviewHelper.makeCategory()
    CategoryDetailView(category: category)
        .modelContainer(PreviewHelper.container)
}
