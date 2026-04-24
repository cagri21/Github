import SwiftUI

struct GitAsyncAvatar: View {
    let url: URL?
    let fallbackSymbol: GitSymbol
    let style: GitAsyncAvatarStyle

    var body: some View {
        decoratedAvatar {
            AsyncImage(
                url: url,
                transaction: Transaction(
                    animation: .easeInOut(duration: style.motion.transitionDuration)
                )
            ) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    fallbackIcon
                }
            }
            .background(
                style.surface.backgroundColor.opacity(style.surface.backgroundOpacity)
            )
        }
    }
}

private extension GitAsyncAvatar {
    @ViewBuilder
    func decoratedAvatar<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        switch style.shape {
        case .circle:
            content()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style.surface.borderColor, lineWidth: style.surface.borderWidth)
                )
                .shadow(color: style.shadow.color, radius: style.shadow.radius)
        case let .rounded(cornerRadius):
            content()
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                    .stroke(style.surface.borderColor, lineWidth: style.surface.borderWidth)
                )
                .shadow(color: style.shadow.color, radius: style.shadow.radius)
        }
    }

    var fallbackIcon: some View {
        Image(systemName: fallbackSymbol.systemName)
            .font(.system(size: style.fallback.iconSize, weight: .semibold))
            .foregroundStyle(style.fallback.iconColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
