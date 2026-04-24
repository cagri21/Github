import SwiftUI

struct GitBorderOverlayModifier: ViewModifier {
    let color: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
            .stroke(color, lineWidth: lineWidth)
        )
    }
}
