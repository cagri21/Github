import SwiftUI

struct GitPerspectiveGridGeometry {
    let horizonRatio: CGFloat
    let horizontalLineCount: ClosedRange<Int>
    let rowSpacing: CGFloat
}

struct GitPerspectiveGridLineStyle {
    let lineWidth: CGFloat
    let horizontalOpacity: Double
    let verticalOpacity: Double
}

struct GitPerspectiveGridVerticalStyle {
    let lineRange: ClosedRange<Int>
    let horizonSpacing: CGFloat
    let bottomSpacing: CGFloat
}

struct GitPerspectiveGridStyle {
    let geometry: GitPerspectiveGridGeometry
    let line: GitPerspectiveGridLineStyle
    let vertical: GitPerspectiveGridVerticalStyle
}

struct GitPerspectiveGrid: View {
    let lineColor: Color
    let style: GitPerspectiveGridStyle

    var body: some View {
        Canvas { context, size in
            let horizon = size.height * style.geometry.horizonRatio
            let centerX = size.width * GitAppTheme.Ratio.half

            for index in style.geometry.horizontalLineCount {
                let y = horizon + CGFloat(index) * style.geometry.rowSpacing
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(
                    path,
                    with: .color(lineColor.opacity(style.line.horizontalOpacity)),
                    lineWidth: style.line.lineWidth
                )
            }

            for index in style.vertical.lineRange {
                var path = Path()
                path.move(
                    to: CGPoint(
                        x: centerX + CGFloat(index) * style.vertical.horizonSpacing,
                        y: horizon
                    )
                )
                path.addLine(
                    to: CGPoint(
                        x: centerX + CGFloat(index) * style.vertical.bottomSpacing,
                        y: size.height
                    )
                )
                context.stroke(
                    path,
                    with: .color(lineColor.opacity(style.line.verticalOpacity)),
                    lineWidth: style.line.lineWidth
                )
            }
        }
    }
}
