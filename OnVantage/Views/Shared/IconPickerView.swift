//
//  IconPickerView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftUI
import SwiftData

struct IconPickerView: View {
    @Binding var selection: String

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(AppConstants.categoryIcons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .background(
                        icon == selection
                            ? Color.accentColor.opacity(0.2)
                            : Color.secondary.opacity(0.1)
                    )
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                icon == selection ? Color.accentColor : .clear,
                                lineWidth: 2
                            )
                    )
                    .onTapGesture { selection = icon }
            }
        }
    }
}

#if DEBUG
    #Preview {
        IconPickerPreviewWrapper()
            .modelContainer(PreviewHelper.container)
            .padding()
    }

    private struct IconPickerPreviewWrapper: View {
        @State private var selection: String = "star.fill"

        var body: some View {
            IconPickerView(selection: $selection)
        }
    }
#endif
