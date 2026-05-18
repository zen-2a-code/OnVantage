//
//  ImportIdleView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 18.05.26.
//

import SwiftData
import SwiftUI

struct ImportIdleView: View {
    var viewModel: ImportCategoryView.ViewModel

    private let promptTemplate = """
        You are generating content for a daily challenge iOS app.

        Return ONLY a valid JSON object — no explanation, no markdown, no code blocks.

        [----> Replace this with your actual request. Example: "Create a mindfulness category with 10 challenges about meditation and breathing exercises (Wim Hof Method). Use random order. 
        Challenge 1 - Do a WIM hof method for 2 rounds 30 times, then take 20 seconds cold shower
        Challenge 2 - take 2 miniutes cold shower
        Challenge 3 - cold plunge
        <---]

        Use exactly this format:
        {
          "category_name": "Fitness",
          "is_ordered": false,
          "challenges": [
            {
              "title": "Push-up challenge",
              "concept_explanation": "Push-ups are a compound bodyweight exercise targeting chest, shoulders, and triceps. They build functional strength and require no equipment.",
              "task_description": "Complete 3 sets of 10 push-ups with 60 seconds rest between sets.",
              "difficulty": 2
            }
          ]
        }

        Rules:
        - difficulty: 1 = easy, 2 = medium, 3 = hard (only these values)
        - Include from 5 to (users choices) challenges
        - is_ordered: true if challenges build on each other, false for random order
        - concept_explanation: 2–3 sentences on the why and what
        - task_description: 1–2 sentences, specific and actionable for one day
        - Return ONLY the JSON (the .json file) — nothing else
        """

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("How it works", systemImage: "info.circle")
                        .font(.headline)
                    Text("1. Copy the prompt below")
                    Text(
                        "2. Paste it into ChatGPT/Gemini/Claude any other LLM and describe your category"
                    )
                    Text("3. Save the AI response as a .json file")
                    Text("4. Select that file here")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("AI Prompt Template", systemImage: "doc.text")
                            .font(.headline)
                        Spacer()
                        Button {
                            UIPasteboard.general.string = promptTemplate
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                    }

                    Text(promptTemplate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 16))

                Button {
                    viewModel.showFilePicker = true
                } label: {
                    Label(
                        "Select JSON File",
                        systemImage: "square.and.arrow.down"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    ImportIdleView(
        viewModel: ImportCategoryView.ViewModel(
            modelContext: PreviewHelper.container.mainContext
        )
    )
    .modelContainer(PreviewHelper.container)
}
