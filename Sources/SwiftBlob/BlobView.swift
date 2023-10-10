import SwiftUI
import Combine

public struct BlobView: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    /// Reasonable range is 0.1 to 1
    var spikyness: Double
    var isAnimated: Bool

    @State private var points: AnimatableCGPointVector

    public init(spikyness: Double = 0.1, isAnimated: Bool = true, points: AnimatableCGPointVector? = nil) {
        self.spikyness = spikyness
        self.isAnimated = isAnimated
        if let points {
            self.points = points
        } else {
            self.points = BlobView.getPoints(for: spikyness)
        }
    }

    public var body: some View {
        BlobShape(controlPoints: points)
            .aspectRatio(1, contentMode: .fit)
            .onReceive(timer) { _ in
                if isAnimated {
                    withAnimation(.easeInOut(duration: 8)) {
                        points = BlobView.getPoints(for: spikyness)
                    }
                }
            }
    }

    public static func getPoints(for spikyness: CGFloat) -> AnimatableCGPointVector {
        let minGrowth = 10 - (spikyness * 10)
        let edges = max(4, Int(spikyness * 50))
        return BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        BlobView(spikyness: 0.3, isAnimated: true)
            .foregroundColor(.white)
        BlobView(spikyness: 0.9, isAnimated: true)
            .foregroundColor(.yellow)
    }
    .frame(width: 300, height: 300)
}
