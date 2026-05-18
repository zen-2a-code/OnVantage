//
//  GradientPickerView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI

struct GradientPickerView: View {
    @Binding var selection: CategoryGradient

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(CategoryGradient.allCases) { gradient in
                Circle()
                    .fill(gradient.gradient)
                    .frame(width: 44)
                    .overlay(
                        selection == gradient
                            ? Circle().stroke(Color.primary, lineWidth: 3)
                            : nil
                    )
                    .onTapGesture { selection = gradient }
            }
        }
    }
}
