import Foundation

/// A normalized 2D landmark emitted by a pose-detection request.
public struct JointPoint: Sendable, Equatable {
    public let x: Double
    public let y: Double
    public let confidence: Double

    public init(x: Double, y: Double, confidence: Double = 1) {
        self.x = x
        self.y = y
        self.confidence = confidence
    }
}

public enum PoseMath {
    /// Returns the angle ABC in degrees, or nil when any landmark is unreliable.
    public static func angle(first: JointPoint, vertex: JointPoint, last: JointPoint, minimumConfidence: Double = 0.5) -> Double? {
        guard [first, vertex, last].allSatisfy({ $0.confidence >= minimumConfidence }) else { return nil }

        let firstVector = (x: first.x - vertex.x, y: first.y - vertex.y)
        let lastVector = (x: last.x - vertex.x, y: last.y - vertex.y)
        let dot = firstVector.x * lastVector.x + firstVector.y * lastVector.y
        let firstLength = hypot(firstVector.x, firstVector.y)
        let lastLength = hypot(lastVector.x, lastVector.y)

        guard firstLength > 0, lastLength > 0 else { return nil }
        let cosine = max(-1, min(1, dot / (firstLength * lastLength)))
        return acos(cosine) * 180 / .pi
    }
}

