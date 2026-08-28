import XCTest
@testable import DoQuestCore

final class DoQuestCoreTests: XCTestCase {
    func testRepRequiresFullMovementCycle() {
        var counter = RepCounter()

        XCTAssertFalse(counter.ingest(elbowAngle: 60))
        XCTAssertFalse(counter.ingest(elbowAngle: 160))
        XCTAssertFalse(counter.ingest(elbowAngle: 55))
        XCTAssertTrue(counter.ingest(elbowAngle: 155))
        XCTAssertEqual(counter.repCount, 1)
    }

    func testLowConfidenceLandmarkDoesNotProduceAngle() {
        let angle = PoseMath.angle(
            first: .init(x: 0, y: 1),
            vertex: .init(x: 0, y: 0),
            last: .init(x: 1, y: 0, confidence: 0.2)
        )
        XCTAssertNil(angle)
    }

    func testQuestOnlyAwardsOncePerDayAndTracksStreak() {
        var progress = QuestProgress()
        let calendar = Calendar(identifier: .gregorian)
        let firstDay = Date(timeIntervalSince1970: 1_700_000_000)
        let secondDay = calendar.date(byAdding: .day, value: 1, to: firstDay)!

        XCTAssertTrue(progress.completeDailyQuest(on: firstDay, calendar: calendar))
        XCTAssertFalse(progress.completeDailyQuest(on: firstDay, calendar: calendar))
        XCTAssertTrue(progress.completeDailyQuest(on: secondDay, calendar: calendar))
        XCTAssertEqual(progress.xp, 200)
        XCTAssertEqual(progress.streak, 2)
    }
}
