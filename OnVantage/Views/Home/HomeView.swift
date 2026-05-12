//
//  HomeView.swift
//  OnVantage
//
//  Created by Stoyan Hristov on 4.05.26.
//

internal import Combine
import SwiftData
import SwiftUI

struct HomeView: View {
    var categories: [ChallengeCategory]
    var activeCategories: [ChallengeCategory] {
        categories.filter { $0.isActive }
    }
    @State var hourGlassRotationAngle: Double = 0.0
    @State private var timeUntilTomorrow: String =
        "23 hours, 59 minutes, 59 seconds."
    let hourglassRotationTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    let countDownTimer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    private func calculateTimeUntilTomorrow() -> String {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfTomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfToday
        )!

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full

        return formatter.string(from: .now, to: startOfTomorrow)
            ?? "Unknown time"
    }

    func getTimeLeftOrCompleteText(for category: ChallengeCategory) -> String {
        if let progress = category.progress {
            if ChallengeProvider.nextChallenge(for: progress) == .doneForToday {
                return "This category challenges are done for today!"
            } else if ChallengeProvider.nextChallenge(for: progress) == .empty {
                return "No challenges for this category"
            } else {
                return timeUntilTomorrow
            }
        }
        return ""
    }

    func isThereChallengeForToday(for category: ChallengeCategory) -> Bool {

        guard let progress = category.progress else { return false }
        if case .challenge = ChallengeProvider.nextChallenge(for: progress) {
            return true
        }
        return false
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(activeCategories) { category in
                    VStack {
                        Text(category.name)
                            .font(.largeTitle)

                        VStack(spacing: 13) {
                            if isThereChallengeForToday(for: category) {
                                Text("Time remaining:")
                                    .foregroundStyle(.secondary)
                                Text(getTimeLeftOrCompleteText(for: category))
                                Image(systemName: "hourglass.bottomhalf.filled")
                                    .foregroundStyle(.secondary)
                                    .font(.largeTitle)
                                    .rotationEffect(
                                        .degrees(hourGlassRotationAngle)
                                    )

                                Button {

                                } label: {
                                    Text("Ready?")
                                        .padding()
                                        .background(.white.opacity(0.4))
                                        .clipShape(.rect(cornerRadius: 20))
                                }
                            } else {
                                VStack(spacing: 13) {
                                    Text(
                                        getTimeLeftOrCompleteText(for: category)
                                    )
                                    .font(.headline)
                                    Image(systemName: "hands.and.sparkles")
                                        .foregroundStyle(.secondary)
                                        .font(.largeTitle)
                                    Text("Good job!")
                                    Text("Or add some more?")
                                        .foregroundStyle(.secondary)
                                        .font(.caption2)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300, height: 200)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        CategoryGradient(rawValue: category.gradientName)?
                            .gradient
                    )
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Daily Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                timeUntilTomorrow = calculateTimeUntilTomorrow()
            }
            .animation(.smooth, value: hourGlassRotationAngle)
            .animation(.smooth, value: timeUntilTomorrow)
            .onReceive(hourglassRotationTimer) { _ in
                hourGlassRotationAngle = hourGlassRotationAngle == 0 ? 180 : 0
            }
            .onReceive(countDownTimer) { _ in
                timeUntilTomorrow = calculateTimeUntilTomorrow()
            }
        }
    }
}

#if DEBUG
    private struct PreviewHelperView<Content: View>: View {
        @Query var categories: [ChallengeCategory]
        let content: ([ChallengeCategory]) -> Content

        var body: some View {
            content(categories)
        }
    }

    #Preview {
        let container = PreviewHelper.container
        UserDefaults.standard.removeObject(forKey: "didSeedV1")
        SeedImporter.loadSeedData(context: container.mainContext)

        return
            PreviewHelperView { categories in
                HomeView(categories: categories)
            }
            .modelContainer(container)

    }
#endif
