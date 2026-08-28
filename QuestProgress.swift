import Foundation

public struct QuestProgress: Sendable, Equatable {
    public private(set) var xp = 0
    public private(set) var streak = 0
    public private(set) var lastCompletedDay: Date?

    public init() {}

    /// Completes a daily quest. Calling twice on the same day never grants duplicate XP.
    @discardableResult
    public mutating func completeDailyQuest(on date: Date, calendar: Calendar = .current) -> Bool {
        let day = calendar.startOfDay(for: date)
        if let lastCompletedDay, calendar.isDate(lastCompletedDay, inSameDayAs: day) { return false }

        if let lastCompletedDay,
           let yesterday = calendar.date(byAdding: .day, value: -1, to: day),
           calendar.isDate(lastCompletedDay, inSameDayAs: yesterday) {
            streak += 1
        } else {
            streak = 1
        }

        xp += 100
        lastCompletedDay = day
        return true
    }
}

