// From https://gist.github.com/mecid/04ab91f45fec501e72e4d5fb02277f3f

import SwiftUI

struct AnimatableCGPointVector: VectorArithmetic {
    static var zero = AnimatableCGPointVector(values: [.zero])

    static func - (lhs: AnimatableCGPointVector, rhs: AnimatableCGPointVector) -> AnimatableCGPointVector {
        let values = zip(lhs.values, rhs.values)
            .map { lhs, rhs in lhs.animatableData - rhs.animatableData }
            .map { CGPoint(x: $0.first, y: $0.second) }
        return AnimatableCGPointVector(values: values)
    }

    static func -= (lhs: inout AnimatableCGPointVector, rhs: AnimatableCGPointVector) {
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            lhs.values[index].animatableData -= rhs.values[index].animatableData
        }
    }

    static func + (lhs: AnimatableCGPointVector, rhs: AnimatableCGPointVector) -> AnimatableCGPointVector {
        let values = zip(lhs.values, rhs.values)
            .map { lhs, rhs in lhs.animatableData + rhs.animatableData }
            .map { CGPoint(x: $0.first, y: $0.second) }
        return AnimatableCGPointVector(values: values)
    }

    static func += (lhs: inout AnimatableCGPointVector, rhs: AnimatableCGPointVector) {
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            lhs.values[index].animatableData += rhs.values[index].animatableData
        }
    }

    mutating func scale(by rhs: Double) {
        for index in 0..<values.count {
            values[index].animatableData.scale(by: rhs)
        }
    }

    var values: [CGPoint]

    var magnitudeSquared: Double {
        values
            .map { $0.animatableData.magnitudeSquared }
            .reduce(0.0, +)
    }
}
