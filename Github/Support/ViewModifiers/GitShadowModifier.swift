import SwiftUI

struct GitShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    func body(content: Content) -> some View {
        content.shadow(
            color: color,
            radius: radius,
            x: x,
            y: y
        )
    }
}
