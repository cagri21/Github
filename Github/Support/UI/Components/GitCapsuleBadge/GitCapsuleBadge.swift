import SwiftUI

struct GitCapsuleBadge: View {
    let title: String
    let style: GitCapsuleBadgeStyle

    var body: some View {
        Text(title)
            .font(style.font)
            .foregroundStyle(style.foregroundColor)
            .lineLimit(GitAppTheme.LineLimit.single)
            .padding(.horizontal, style.horizontalPadding)
            .frame(height: style.height)
            .background(
                Capsule(style: .continuous)
                    .fill(style.backgroundColor)
            )
    }
}
