import SwiftUI

struct GitUnderlineModifier: ViewModifier {
    let color: Color
    let lineHeight: CGFloat
    let bottomSpacing: CGFloat

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            Rectangle()
                .fill(color)
                .frame(height: lineHeight)
                .offset(y: bottomSpacing)
        }
    }
}
