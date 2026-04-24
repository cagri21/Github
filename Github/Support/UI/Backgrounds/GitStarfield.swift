import SwiftUI

struct GitStarfieldStar: Hashable {
    let position: CGPoint
    let size: CGFloat
    let opacity: Double
}

struct GitStarfield: View {
    let color: Color
    let stars: [GitStarfieldStar]

    var body: some View {
        GeometryReader { proxy in
            ForEach(Array(stars.enumerated()), id: \.offset) { _, star in
                Circle()
                    .fill(color.opacity(star.opacity))
                    .frame(width: star.size, height: star.size)
                    .position(
                        x: star.position.x * proxy.size.width,
                        y: star.position.y * proxy.size.height
                    )
            }
        }
    }
}
