import Foundation

public enum RepPhase: Sendable, Equatable {
    case waitingForExtension
    case waitingForContraction
    case waitingForReturn
}

/// Counts a bicep curl only after the arm moves from extended → contracted → extended.
public struct RepCounter: Sendable {
    public private(set) var repCount = 0
    public private(set) var phase: RepPhase = .waitingForExtension

    private let extendedThreshold: Double
    private let contractedThreshold: Double

    public init(extendedThreshold: Double = 150, contractedThreshold: Double = 65) {
        precondition(contractedThreshold < extendedThreshold, "Contracted threshold must be below extended threshold.")
        self.extendedThreshold = extendedThreshold
        self.contractedThreshold = contractedThreshold
    }

    /// Feed consecutive elbow angles from pose detection. Returns true precisely when a rep is completed.
    @discardableResult
    public mutating func ingest(elbowAngle: Double?) -> Bool {
        guard let elbowAngle else { return false }

        switch phase {
        case .waitingForExtension where elbowAngle >= extendedThreshold:
            phase = .waitingForContraction
        case .waitingForContraction where elbowAngle <= contractedThreshold:
            phase = .waitingForReturn
        case .waitingForReturn where elbowAngle >= extendedThreshold:
            repCount += 1
            phase = .waitingForContraction
            return true
        default:
            break
        }
        return false
    }
}

