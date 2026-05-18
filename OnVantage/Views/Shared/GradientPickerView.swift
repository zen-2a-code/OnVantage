//
//  GradientPickerView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI
import SwiftData

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

#if DEBUG
    #Preview {
        GradientPickerPreviewWrapper()
            .modelContainer(PreviewHelper.container)
            .padding()
    }

    private struct GradientPickerPreviewWrapper: View {
        @State private var selection: CategoryGradient = .ocean

        var body: some View {
            GradientPickerView(selection: $selection)
        }
    }
#endif
