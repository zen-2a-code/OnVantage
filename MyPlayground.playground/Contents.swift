import Cocoa

var greeting = "Hello, playground"

enum StreakCalculator {
    static func recordCompletion(for _: Category) {
        let currentDate = Date.now
        print(currentDate)
    }
}

let currentDate = Date.now

print(currentDate)
