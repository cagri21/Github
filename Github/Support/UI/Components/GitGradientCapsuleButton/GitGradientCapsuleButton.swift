import SwiftUI

struct GitGradientCapsuleButton: View {
    let title: String
    let style: GitGradientCapsuleButtonStyle
    let accessibilityIdentifier: String?
    let action: () -> Void

    init(
        title: String,
        style: GitGradientCapsuleButtonStyle,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    @ViewBuilder
    var body: some View {
        if let accessibilityIdentifier {
            styledButton
                .accessibilityIdentifier(accessibilityIdentifier)
        } else {
            styledButton
        }
    }
}

private extension GitGradientCapsuleButton {
    var styledButton: some View {
        button
            .buttonStyle(.plain)
            .shadow(color: style.shadow.color, radius: style.shadow.radius)
    }

    var button: some View {
        Button(action: action) {
            Text(title)
                .font(style.typography.font)
                .foregroundStyle(style.typography.foregroundColor)
                .frame(width: style.layout.width, height: style.layout.height)
                .background(
                    Capsule(style: .continuous)
                        .fill(style.fill.fillStyle)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(style.border.color, lineWidth: style.border.width)
                )
        }
    }
}
