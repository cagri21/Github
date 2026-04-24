import SwiftUI

struct GitFloorGlow: View {
    let colors: [Color]
    let startRadius: CGFloat
    let endRadius: CGFloat
    let blurRadius: CGFloat
    let maxWidth: CGFloat
    let maxHeight: CGFloat

    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: colors,
                    center: .center,
                    startRadius: startRadius,
                    endRadius: endRadius
                )
            )
            .blur(radius: blurRadius)
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
