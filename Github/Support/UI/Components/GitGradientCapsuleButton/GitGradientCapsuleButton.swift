import SwiftUI

struct GitGradientCapsuleButton: View {
    let title: String
    let style: GitGradientCapsuleButtonStyle
    let action: () -> Void

    var body: some View {
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
        .buttonStyle(.plain)
        .shadow(color: style.shadow.color, radius: style.shadow.radius)
    }
}
