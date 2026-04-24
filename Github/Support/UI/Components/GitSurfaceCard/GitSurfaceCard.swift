import SwiftUI

struct GitSurfaceCard<Content: View>: View {
    let style: GitSurfaceCardStyle
    private let content: Content

    init(
        style: GitSurfaceCardStyle,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: style.shape.cornerRadius, style: .continuous)
                    .fill(style.fill.color)
            )
            .overlay(
                RoundedRectangle(cornerRadius: style.shape.cornerRadius, style: .continuous)
                    .stroke(style.border.color, lineWidth: style.border.width)
            )
            .shadow(color: style.shadow.color, radius: style.shadow.radius)
    }
}
