import SwiftUI

/// A Blob shape, requires vector controlPoints from Blob.createPoints
struct BlobShape: Shape {
    static let size: CGFloat = 300
    private(set) var controlPoints: AnimatableCGPointVector
    var animatableData: AnimatableCGPointVector {
        get { controlPoints }
        set { controlPoints = newValue }
    }

    static func createPoints(minGrowth: Int, edges: Int) -> AnimatableCGPointVector {
        let outerRadius = Self.size / 2
        let innerRadius = CGFloat(minGrowth) * (outerRadius / 10)
        let center = Self.size / 2
        let slices = divide(count: edges)
        let points: [CGPoint] = slices.map { degree in
            let radius = magicPoint(value: CGFloat.random(in: 0...1), min: innerRadius, max: outerRadius)
            return point(origin: center, radius: radius, degree: degree)
        }
        return AnimatableCGPointVector(values: points)
    }

    func path(in rect: CGRect) -> Path {
        guard controlPoints.values.count > 1 else {
            return Path()
        }
        var path = Path()
        let xScale = rect.width / Self.size
        let yScale = rect.height / Self.size
        let scaledPoints = controlPoints.values.map { point in
            point.scale(x: xScale, y: yScale)
        }

        path.move(to: CGPoint(x: (scaledPoints[0].x + scaledPoints[1].x) / 2,
                              y: (scaledPoints[0].y + scaledPoints[1].y) / 2))

        (0..<controlPoints.values.count).forEach { index in
            let point1 = scaledPoints[(index + 1) % controlPoints.values.count]
            let point2 = scaledPoints[(index + 2) % controlPoints.values.count]
            let midX = (point1.x + point2.x) / 2
            let midY = (point1.y + point2.y) / 2
            path.addQuadCurve(to: CGPoint(x: midX, y: midY), control: point1)
        }

        return path
    }

    static private func toRad(_ degree: CGFloat) -> CGFloat {
        Angle(degrees: degree).radians
    }

    static private func divide(count: Int) -> [CGFloat] {
        (0..<count).map {
            CGFloat($0) * (360 / CGFloat(count))
        }
    }

    static private func magicPoint(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        let radius = min + value * (max - min)
        if radius > max {
            return radius - min
        } else if radius < min {
            return radius + min
        }
        return radius
    }

    static private func point(origin: CGFloat, radius: CGFloat, degree: CGFloat) -> CGPoint {
        CGPoint(
            x: (origin + radius * cos(toRad(degree))).rounded(),
            y: (origin + radius * sin(toRad(degree))).rounded()
        )
    }

}

fileprivate extension CGPoint {
    func scale(x xScale: CGFloat, y yScale: CGFloat) -> CGPoint {
        CGPoint(x: x * xScale, y: y * yScale)
    }
}
